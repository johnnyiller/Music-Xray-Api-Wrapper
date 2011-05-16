module MusicXrayApi

  class TrackSet < ActiveResource::Base
    
    
    
  
    def self.set_headers
      self.site = 'https://api.musicxray.com'
      date = MusicXrayApi::Base.rfc2616(Time.now)
      headers['Date'] = date.to_s
      headers['X-Xray-Authorization'] = MusicXrayApi::Base.sign_https_requestv3(date)
    end
  end
  
  
  
end