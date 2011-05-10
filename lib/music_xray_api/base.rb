module MusicXrayApi
  class Base
       
    def self.rfc2616(time)
      time.utc.strftime("%a, %d %b %Y %H:%M:%S")+" +0000"
    end
    def self.sign_https_request(request,date,secret,key) 
      return "{'client_key_id':'#{key}', 'algorithm':'HmacSHA256', 'signature':'#{Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), secret, date)).strip}'}"
    end
    def self.make_request(secret,key,postfix,form_hash)
      date = MusicXrayApi::Base.rfc2616(Time.now)
      uri = URI.parse("https://api-load-balancer-467937692.us-east-1.elb.amazonaws.com/#{postfix}.xml")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(form_hash)
      request['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8'
      request.add_field("Date",date)
      request.add_field("X-Xray-Authorization",MusicXrayApi::Base.sign_https_request(request,date,secret,key))
      response = http.request(request)
      #puts response.inspect
      case response
        when Net::HTTPSuccess then return response
        when Net::HTTPClientError then raise response.body
        when Net::HTTPServerError then raise response.body
        else raise response.body
      end
      #return response
    end
    
  end
end