require 'helper'


class TestMusicXrayApi < Test::Unit::TestCase
  context "Has valid credentials" do 
    setup do 
      YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
      MusicXrayApi::Base.key = @key
      MusicXrayApi::Base.secret = @secret
      MusicXrayApi::Track.set_headers
      MusicXrayApi::TrackSet.set_headers
      MusicXrayApi::TrackSetMember.set_headers
      MusicXrayApi::TrackMatchRequest.set_headers
      
    end
    should "Be able to create a track." do
      tr = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}"})
      puts tr.id
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
      t1 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}1"})
      t2 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}2"})
      t3 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>"xray/#{Time.now.to_i.to_s}3"})
      ts = MusicXrayApi::TrackSet.create({:name=>"whatever it's just a name"})
      tsm = MusicXrayApi::TrackSetMember.create({:track_id=>t1.id, :track_set_id=>ts.id})
      tsm = MusicXrayApi::TrackSetMember.create({:track_id=>t2.id, :track_set_id=>ts.id})
      # testing matching request capable
      tmr = MusicXrayApi::TrackMatchRequest.create({:track_id=>t3.id, :track_set_id=>ts.id,:result_delivery_method=>'none'})
      
    end
    
  end
end


