module MusicXrayApi

  class Tracks
    def self.create(secret,key,params={})
      begin
        MusicXrayApi::Base.make_request(secret,key,"tracks",params)
      rescue Exception=>e
        puts e.to_s
        raise e.to_s
      end
    end
  end

end