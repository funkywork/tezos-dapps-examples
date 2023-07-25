type state =
  | Not_connected
  | Connected of { address : Yourbones.Address.t }

type t =
  { state : state
  ; errors : string list
  }

let update model = function
  | Message.Noop -> Vdom.return model
;;

let not_connected = { errors = []; state = Not_connected }
let connected ~address = { errors = []; state = Connected { address } }

let init dapp_client : (t * Message.t Vdom.Cmd.t) Lwt.t =
  let open Lwt.Syntax in
  let* active_account = Beacon.Dapp_client.get_active_account dapp_client in
  match active_account with
  | None -> not_connected |> Vdom.return |> Lwt.return
  | Some Beacon.Account_info.{ address; _ } ->
    connected ~address |> Vdom.return |> Lwt.return
;;
