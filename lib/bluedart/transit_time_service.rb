module Bluedart
    class TransitTimeService < Bluedart::Base
      def initialize(details)
        @request_params = details[:request_params]
        @profile = profile_hash({api_type: 'S', version: '1.3'}, details[:creds])
        @mode = details[:mode]
      end
  
      def request_url
        if @mode == 'prod'
          'http://netconnect.bluedart.com/Ver1.8/ShippingAPI/Finder/ServiceFinderQuery.svc'
        else
          'http://netconnect.bluedart.com/Ver1.8/Demo/ShippingAPI/Finder/ServiceFinderQuery.svc'
        end
      end
  
      def response
        wsa = 'http://tempuri.org/IServiceFinderQuery/GetDomesticTransitTimeForPinCodeandProduct'
        opts = {message: 'GetDomesticTransitTimeForPinCodeandProduct', wsa: wsa, params: @request_params, extra: {'profile' => @profile}, url: request_url}
        make_request(opts)
      end
    end
  end
  