let connect : Nightmare_dream.service =
  Nightmare_service.Service.straight
    ~endpoint:Endpoint.connect
    (Template.spa
       ~app_id:"connect-app"
       ~title:"A simple dApp that demonstrates how to sync Wallet with dApp"
       [ "tezos_dapps_examples.mountConnect('connect-app')" ])
;;
