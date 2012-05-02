module MusicXrayApi
  
  class Base
    @@key ||= ""
    @@secret ||= ""

    def self.key= k
      @@key = k
    end
    def self.secret= s
      @@secret = s
    end
    def self.api_endpoint= apiend
      @@api_endpoint = apiend
    end
    def self.api_endpoint
      return @@api_endpoint
    end
    def self.rfc2616(time)
      time.utc.strftime("%a, %d %b %Y %H:%M:%S")+" +0000"
    end
    def self.sign_https_request(request,date,secret,key) 
      return "{'client_key_id':'#{key}', 'algorithm':'HmacSHA256', 'signature':'#{Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), secret, date)).strip}'}"
    end
    def self.sign_https_requestv3(date) 
      return "{'client_key_id':'#{@@key}', 'algorithm':'HmacSHA256', 'signature':'#{Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), @@secret, date)).strip}'}"
    end
  end
end
module ResourceMethods
  def self.included(klass)
    klass.extend ClassMethods
  end
  module ClassMethods
    def set_headers
      self.site = MusicXrayApi::Base.api_endpoint
      date = MusicXrayApi::Base.rfc2616(Time.now)
      headers['Date'] = date.to_s
      headers['X-Xray-Authorization'] = MusicXrayApi::Base.sign_https_requestv3(date)
    end
  end
end