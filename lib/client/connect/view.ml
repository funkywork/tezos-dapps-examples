let not_connected () =
  let open Nightmare_js_vdom in
  [ button
      ~a:
        [ a_class [ "btn"; "black-container" ]
        ; on_click Message.ask_for_wallet_sync
        ]
      [ txt "Sync Wallet" ]
  ]
;;

let connected account_info =
  let open Nightmare_js_vdom in
  let address_str =
    Yourbones.Address.to_string account_info.Beacon.Account_info.address
  in
  [ div [ span [ txt @@ "connected as " ^ address_str ] ]
  ; button
      ~a:
        [ a_class [ "btn"; "black-container" ]
        ; on_click Message.ask_for_wallet_unsync
        ]
      [ txt "Unsync Wallet" ]
  ]
;;

let main_content state =
  let open Nightmare_js_vdom in
  main
    (match state with
     | Model.Not_connected -> not_connected ()
     | Model.Connected { account } -> connected account)
;;

let index Model.{ state; errors = _ } =
  let open Nightmare_js_vdom in
  div
    [ header
        [ h1 [ txt "CONNECT" ]
        ; h2
            [ txt
                "Simply connect a wallet with a dApp and stream the head of \
                 the chain"
            ]
        ]
    ; main_content state
    ]
;;
