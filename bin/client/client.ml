open Js_of_ocaml
open Nightmare_js

let () = Suspension.allow ()

let () =
  Js.export
    "tezos_dapps_examples"
    (object%js
       method mountConnect container_id =
         let id = Js.to_string container_id in
         Dapp_connect.mount id
    end)
;;
