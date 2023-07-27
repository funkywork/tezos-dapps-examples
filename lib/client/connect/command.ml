type 'msg Vdom.Cmd.t +=
  | Sync_wallet of
      { on_success : Beacon.Account_info.t -> Yourbones.Tez.t -> 'msg
      ; on_failure : string -> 'msg
      }
  | Unsync_wallet of { on_success : unit -> 'msg }
  | Stream_head of
      { address : Yourbones.Address.t
      ; on_success : Yourbones.Tez.t -> Yourbones.Block_header.t -> 'msg
      }

let get_balance address =
  Yourbones_js.RPC.call
    ~node_address:Network.node_address
    Yourbones.RPC.Directory.get_balance
    Yourbones.Chain_id.main
    Yourbones.Block_id.head
    address
;;

let sync_wallet dapp_client ctx on_success on_failure () =
  let open Common.Lwt_util in
  let* account = Beacon.Dapp_client.get_active_account dapp_client in
  let* account_with_balance =
    let*? account =
      match account with
      | Some active -> Lwt.return (Ok active)
      | None ->
        let+? Beacon.Permission_response_output.{ account_info; _ } =
          Beacon.Dapp_client.request_permissions dapp_client
        in
        account_info
    in
    let*? balance = get_balance account.address in
    Lwt.return_ok (account, balance)
  in
  let message =
    match account_with_balance with
    | Ok (account, balance) -> on_success account balance
    | Error _ ->
      let () = Nightmare_js.Console.(string error) "Error connecting wallet" in
      on_failure "Unable to sync wallet"
  in
  Lwt.return @@ Vdom_blit.Cmd.send_msg ctx message
;;

let unsync_wallet dapp_client ctx on_success () =
  let open Common.Lwt_util in
  let+ () = Beacon.Dapp_client.clear_active_account dapp_client in
  let msg = on_success () in
  Vdom_blit.Cmd.send_msg ctx msg
;;

let stream_head ctx address on_success () =
  let open Common.Lwt_util in
  let+ _ =
    Yourbones_js.RPC.stream
      ~node_address:Network.node_address
      ~on_chunk:(fun header ->
        let+? balance = get_balance address in
        let msg = on_success balance header in
        Vdom_blit.Cmd.send_msg ctx msg)
      Yourbones.RPC.Directory.monitor_heads
      Yourbones.Chain_id.main
  in
  ()
;;

let register dapp_client =
  let open Vdom_blit in
  let handler =
    Cmd.
      { f =
          (fun ctx -> function
            | Sync_wallet { on_success; on_failure } ->
              let () =
                Lwt.dont_wait
                  (sync_wallet dapp_client ctx on_success on_failure)
                  Nightmare_js.Console.error
              in
              true
            | Unsync_wallet { on_success } ->
              let () =
                Lwt.dont_wait
                  (unsync_wallet dapp_client ctx on_success)
                  Nightmare_js.Console.error
              in
              true
            | Stream_head { address; on_success } ->
              let () =
                Lwt.dont_wait
                  (stream_head ctx address on_success)
                  Nightmare_js.Console.error
              in
              true
            | _ -> false)
      }
  in
  register @@ cmd handler
;;

let ask_wallet_sync on_success on_failure =
  Sync_wallet { on_success; on_failure }
;;

let ask_wallet_unsync on_success = Unsync_wallet { on_success }
let ask_stream_head address on_success = Stream_head { address; on_success }
