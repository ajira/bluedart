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

      private

      def namespaces
        ns = {}
        ns[:envelope] = {key:'env', value: 'http://www.w3.org/2003/05/soap-envelope'}
        ns[:content]  = {key:'ns2', value: 'http://tempuri.org/'}
        ns[:profile]  = {key:'ns3', value: 'http://schemas.datacontract.org/2004/07/SAPI.Entities.Admin'}
        ns[:request]    = {key:'ns1', value: 'http://schemas.datacontract.org/2004/07/SAPI.Entities.WayBillGeneration'}
        ns[:wsa]      = {key:'ns4', value: 'http://www.w3.org/2005/08/addressing'}
        ns
      end

      def body_xml(xml, message, params, extra)
        content_ns_key = "#{namespace_key(:content)}"
        xml.Body {
          xml[content_ns_key].send(message) do |xml|
            xml[content_ns_key].send("Request") { awb_xml xml }
            extra.each do |key, value|
              xml[content_ns_key].send(key) { profile_xml(xml, value)} if key.downcase == 'profile'
            end
          end
        }
        xml
      end

      def awb_xml(xml)
        xml["ns1"].AWBNo @AWBNo
        xml 
      end

    end
  end