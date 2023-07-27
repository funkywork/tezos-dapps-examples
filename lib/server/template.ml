let page ~title content =
  let page_title = Tyxml.Html.txt title in
  let open Tyxml.Html in
  let open Nightmare_tyxml in
  let content = content @ [ script (txt "nightmare_js.mount();") ] in
  html
    ~a:[ a_lang "en" ]
    (head
       (title page_title)
       [ link_of ~rel:[ `Stylesheet ] Endpoint.priv "style.css"
       ; script_of Endpoint.priv "client.bc.js" ""
       ])
    (body content)
  |> Format.asprintf "%a" (pp ())
  |> Dream.html
;;

let spa ?(app_id = "application") ~title suspends _request =
  let script_instructions = String.concat ";" suspends in
  let script_content =
    "nightmare_js.suspend(function(){" ^ script_instructions ^ "});"
  in
  page
    ~title
    Tyxml.Html.
      [ main
          ~a:[ a_id "spa-content" ]
          [ div
              ~a:[ a_id app_id ]
              [ div
                  ~a:[ a_id "spa-loading" ]
                  [ span [ txt "❖" ]; span [ txt "loading" ] ]
              ]
          ; script (txt script_content)
          ]
      ]
;;
