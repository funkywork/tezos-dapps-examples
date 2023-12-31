open Nightmare_js

let dapp_client () =
  Beacon.Dapp_client.make
    ~preferred_network:Network.preferred_network
    ~name:"connect-v1"
    ()
;;

let app client =
  let () = Command.register client in
  let update = Model.update in
  let view = View.index in
  let init = Model.init in
  Nightmare_js_vdom.app ~init ~update ~view ()
;;

let mount container_id =
  Nightmare_js_vdom.mount_to ~id:container_id (fun _ ->
    let () = Console.(string info) @@ "mounting Connect in #" ^ container_id in
    let client = dapp_client () in
    Lwt.return @@ app client)
;;
