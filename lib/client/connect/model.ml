type state =
  | Not_connected
  | Connected of
      { account : Beacon.Account_info.t
      ; balance : Yourbones.Tez.t
      ; head : Yourbones.Block_header.t option
      }

type t =
  { state : state
  ; errors : string list
  }

let not_connected = { errors = []; state = Not_connected }

let connected ~account ~balance =
  { errors = []; state = Connected { account; balance; head = None } }
;;

let update_not_connected model = function
  | Message.Command Ask_for_wallet_sync ->
    Vdom.return
      model
      ~c:[ Command.ask_wallet_sync Message.wallet_synced Message.with_error ]
  | Message.Command_result (Wallet_synced { account_info; balance }) ->
    let address = account_info.address in
    Vdom.return
      ~c:[ Command.ask_stream_head address Message.new_head ]
      (connected ~account:account_info ~balance)
  | _ -> Vdom.return model
;;

let update_connected model account = function
  | Message.Command Ask_for_wallet_unsync ->
    Vdom.return model ~c:[ Command.ask_wallet_unsync Message.wallet_unsynced ]
  | Message.Command_result Wallet_unsynced -> Vdom.return not_connected
  | Message.Command_result (New_head { balance; head }) ->
    Vdom.return
      { model with state = Connected { account; balance; head = Some head } }
  | _ -> Vdom.return model
;;

let update ({ state; errors } as model) = function
  | Message.Register_error err ->
    Vdom.return { model with errors = err :: errors }
  | msg ->
    (match state with
     | Not_connected -> update_not_connected model msg
     | Connected { account; _ } -> update_connected model account msg)
;;

let init : t * Message.t Vdom.Cmd.t = Vdom.return not_connected
