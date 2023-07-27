type command =
  | Ask_for_wallet_sync
  | Ask_for_wallet_unsync

type command_result =
  | Wallet_synced of { account_info : Beacon.Account_info.t }
  | Wallet_unsynced

type t =
  | Command of command
  | Command_result of command_result
  | Register_error of string

let ask_for_wallet_sync _ = Command Ask_for_wallet_sync
let ask_for_wallet_unsync _ = Command Ask_for_wallet_unsync
let wallet_unsynced () = Command_result Wallet_unsynced
let wallet_synced account_info = Command_result (Wallet_synced { account_info })
let with_error err = Register_error err
