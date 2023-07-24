let transfer : Nightmare_dream.service =
  Nightmare_service.Service.straight
    ~endpoint:Endpoint.transfer
    (Template.spa
       ~app_id:"transfer-app"
       ~title:"Transfer - an example dApp that performs a transfer"
       [])
;;
