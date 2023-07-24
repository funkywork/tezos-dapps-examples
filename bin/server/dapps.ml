let static_path =
  let open Dream in
  router [ get "/priv/**" @@ static "priv/" ]
;;

let router = Nightmare_dream.router ~services:Server.Router.services

let () =
  Dream.run ~port:8888
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ router
  @@ static_path
;;
