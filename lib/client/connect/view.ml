let main_content state =
  let open Nightmare_js_vdom in
  main
    (match state with
     | Model.Not_connected ->
       [ button
           ~a:[ a_class [ "btn"; "black-container" ] ]
           [ txt "Connect Wallet" ]
       ]
     | Connected _ -> [ txt "connected" ])
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
