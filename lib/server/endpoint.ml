open Nightmare_service.Endpoint

let priv () = get (~/"priv" /: string)
let connect () = get (~/"dapps" / "connect")
