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

let connected account_info balance head =
  let open Nightmare_js_vdom in
  let address_str =
    Yourbones.Address.to_string account_info.Beacon.Account_info.address
  in
  let balance_str = Format.asprintf "%a" Yourbones.Tez.pp_print balance in
  [ div
      [ div [ txt @@ "connected as " ^ address_str ]
      ; div [ txt @@ "balance: " ^ balance_str ]
      ; div
          [ (match head with
             | None -> txt "fetching head"
             | Some h ->
               let hash_str =
                 Yourbones.(h.Block_header.hash |> Block_hash.to_string)
               in
               txt hash_str)
          ]
      ]
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
     | Model.Connected { account; balance; head } ->
       connected account balance head)
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
