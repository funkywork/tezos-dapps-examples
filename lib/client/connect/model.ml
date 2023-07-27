type state =
  | Not_connected
  | Connected of { account : Beacon.Account_info.t }

type t =
  { state : state
  ; errors : string list
  }

let not_connected = { errors = []; state = Not_connected }
let connected ~account = { errors = []; state = Connected { account } }

let update_not_connected model = function
  | Message.Command Ask_for_wallet_sync ->
    Vdom.return
      model
      ~c:[ Command.ask_wallet_sync Message.wallet_synced Message.with_error ]
  | Message.Command_result (Wallet_synced { account_info }) ->
    Vdom.return (connected ~account:account_info)
  | _ -> Vdom.return model
;;

let update_connected model = function
  | Message.Command Ask_for_wallet_unsync ->
    Vdom.return model ~c:[ Command.ask_wallet_unsync Message.wallet_unsynced ]
  | Message.Command_result Wallet_unsynced -> Vdom.return not_connected
  | _ -> Vdom.return model
;;

let update ({ state; errors } as model) = function
  | Message.Register_error err ->
    Vdom.return { model with errors = err :: errors }
  | msg ->
    (match state with
     | Not_connected -> update_not_connected model msg
     | Connected _ -> update_connected model msg)
;;

let init dapp_client : (t * Message.t Vdom.Cmd.t) Lwt.t =
  let open Lwt.Syntax in
  let* active_account = Beacon.Dapp_client.get_active_account dapp_client in
  match active_account with
  | None -> not_connected |> Vdom.return |> Lwt.return
  | Some account -> connected ~account |> Vdom.return |> Lwt.return
;;
