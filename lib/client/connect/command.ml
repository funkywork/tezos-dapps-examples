type 'msg Vdom.Cmd.t +=
  | Sync_wallet of
      { on_success : Beacon.Account_info.t -> 'msg
      ; on_failure : string -> 'msg
      }
  | Unsync_wallet of { on_success : unit -> 'msg }

let sync_wallet dapp_client ctx on_success on_failure () =
  let open Common.Lwt_util in
  let* account = Beacon.Dapp_client.get_active_account dapp_client in
  let* account_info =
    match account with
    | Some active -> Lwt.return (Ok active)
    | None ->
      let+? Beacon.Permission_response_output.{ account_info; _ } =
        Beacon.Dapp_client.request_permissions dapp_client
      in
      account_info
  in
  let message =
    match account_info with
    | Ok account -> on_success account
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
            | _ -> false)
      }
  in
  register @@ cmd handler
;;

let ask_wallet_sync on_success on_failure =
  Sync_wallet { on_success; on_failure }
;;

let ask_wallet_unsync on_success = Unsync_wallet { on_success }
