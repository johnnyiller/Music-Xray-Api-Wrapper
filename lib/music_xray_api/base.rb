class Hash
  def to_url_params
    elements = []
    keys.size.times do |i|
      elements << "#{CGI::escape(keys[i])}=#{CGI::escape(values[i])}"
    end
    elements.join('&')
  end

  def self.from_url_params(url_params)
    result = {}.with_indifferent_access
    url_params.split('&').each do |element|
      element = element.split('=')
      result[element[0]] = element[1]
    end
    result
  end
end

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
    def self.rfc2616(time)
      time.utc.strftime("%a, %d %b %Y %H:%M:%S")+" +0000"
    end
    def self.sign_https_request(request,date,secret,key) 
      return "{'client_key_id':'#{key}', 'algorithm':'HmacSHA256', 'signature':'#{Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), secret, date)).strip}'}"
    end
    def self.sign_https_requestv3(date) 
      return "{'client_key_id':'#{@@key}', 'algorithm':'HmacSHA256', 'signature':'#{Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new("sha256"), @@secret, date)).strip}'}"
    end
    def self.make_request(secret,key,postfix,form_hash,method)
      date = MusicXrayApi::Base.rfc2616(Time.now)
      uri = URI.parse("https://api.musicxray.com/#{postfix}.xml")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      if method.to_s.downcase=="post"
        @request = Net::HTTP::Post.new(uri.request_uri)
        @request.set_form_data(form_hash)
        @request['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8'
      elsif method.to_s.downcase=="get"
        @request = Net::HTTP::Get.new("#{uri.request_uri}?#{form_hash.to_url_params}")
      elsif method.to_s.downcase=="put"
        @request = Net::HTTP::Put.new(uri.request_uri)
        @request.set_form_data(form_hash)
        @request['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8'
      elsif method.to_s.downcase=="delete"
        @request = Net::HTTP::Delete.new("#{uri.request_uri}?#{form_hash.to_url_params}")
      end
      @request.add_field("Date",date)
      @request.add_field("X-Xray-Authorization",MusicXrayApi::Base.sign_https_request(@request,date,secret,key))  
      response = http.request(@request)
      case response
        when Net::HTTPSuccess then return response
        when Net::HTTPClientError then raise "#{response.body}"
        when Net::HTTPServerError then raise "#{response.body}"
        else raise "#{response.body}"
      end
      #return response
    end
    def self.objectify_params(outer,params)
      nar = {}
      params.each do |key,value|
        nar["#{outer}[#{key}]"]=value
      end
      return nar
    end
  end
end