open Nightmare_service.Endpoint

let priv () = get (~/"priv" /: string)
let transfer () = get (~/"dapps" / "transfer")
