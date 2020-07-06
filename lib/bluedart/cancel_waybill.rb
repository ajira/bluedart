module Bluedart
    class CancelWaybill < Base
      def initialize(details)
        @AWBNo = details[:awb_no]
        @profile = profile_hash({api_type: 'S', version: '1.3'}, details[:creds])
        @mode = details[:mode]
      end
  
      def request_url
        if @mode == 'prod'
          'https://netconnect.bluedart.com/Ver1.8/ShippingAPI/WayBill/WayBillGeneration.svc'
        else
          'http://netconnect.bluedart.com/Ver1.8/Demo/ShippingAPI/WayBill/WayBillGeneration.svc'
        end
      end
  
      def response
        wsa = 'http://tempuri.org/IWayBillGeneration/CancelWaybill'
        # TODO: ITS A HACK NEEDS TO BE REMOVED
        # TODO: NEED TO REWRITE TO USE NAMESPACES DEFINED IN NAMESPACES FUNCTION
        params = {'Request' => { 'AWBNo' => @AWBNo }}
        opts = {message: 'CancelWaybill', wsa: wsa, params: params, extra: {'Profile' => @profile}, url: request_url}
        make_request(opts)
      end
  
    end
  end