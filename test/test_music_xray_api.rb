require 'helper'


class TestMusicXrayApi < Test::Unit::TestCase
  context "Has valid credentials" do 
    setup do 
      YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
      MusicXrayApi::Base.key = @key
      MusicXrayApi::Base.secret = @secret
      MusicXrayApi::TrackSet.set_headers
      MusicXrayApi::Track.set_headers
      MusicXrayApi::TrackSetMember.set_headers
      
    end
    should "Be able to create a track." do
      #puts MusicXrayApi::KEY
     # begin
        tr = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}"})
        puts tr.id
    #    puts resp
    #    xml_hash = XmlSimple.xml_in(resp,{'ForceArray' => false })
    #    resp2 = MusicXrayApi::Tracks.find_by_id(@secret,@key,xml_hash["id"]).body
    #    puts resp2
    #    resp3 = MusicXrayApi::Tracks.delete_by_id(@secret,@key,xml_hash["id"])
    #    puts resp3.inspect
    #    resp4 = MusicXrayApi::Tracks.find_by_id(@secret,@key,xml_hash["id"]).body
    #    puts resp4
    #  rescue Exception => e 
    #    puts e.to_s
    #  end
    end
    should "be able to do crud for track sets" do 
      ts = MusicXrayApi::TrackSet.new
      ts.name = "another my new one"
      puts ts.save
      puts ts.id
      unless ts
        ts.errors
      end
      fts = MusicXrayApi::TrackSet.find(ts.id)
      puts fts.name
    end
    should "be able to add a track I create to a track set I also create" do 
      t = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}"})
      ts = MusicXrayApi::TrackSet.create({:name=>"whatever it's just a name"})
      tsm = MusicXrayApi::TrackSetMember.create({:track_id=>t.id, :track_set_id=>ts.id})
      puts tsm.id
    end
    
  end
end


