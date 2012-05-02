require 'helper'


class TestMusicXrayApi < Test::Unit::TestCase
  context "Has valid credentials" do 
    setup do 
      YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
      MusicXrayApi::Base.key = @key
      MusicXrayApi::Base.secret = @secret
      MusicXrayApi::Base.api_endpoint = @endpoint
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
      #fts.destroy
      puts fts.name
    end
    should "be able to add a track I create to a track set I also create" do
      turi1 = "xray/#{Time.now.to_i.to_s}1"
      turi2 = "xray/#{Time.now.to_i.to_s}2"
      turi3 = "xray/#{Time.now.to_i.to_s}3"
      ids = [turi1,turi2]
      t1 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>turi1})
      t2 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>turi2})
      t3 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", :uri=>turi3})
      ts = MusicXrayApi::TrackSet.create({:name=>"whatever it's just a name"})
      tsm = MusicXrayApi::TrackSetMember.create({:track_id=>t1.id, :track_set_id=>ts.id})
      tsm = MusicXrayApi::TrackSetMember.create({:track_id=>t2.id, :track_set_id=>ts.id})
      # testing matching request capable
      tmr = MusicXrayApi::TrackMatchRequest.create({:track_id=>t3.id, :track_set_id=>ts.id,:result_delivery_method=>'none'})
      #puts tsm.inspect
      tsm.destroy
      puts ids.inspect
      tracks = MusicXrayApi::Track.find :all, :params=>{:uris=>ids.join(",")}
      puts tracks.inspect
    end
    should "be able to update a track causing it to re-index" do 
      t = MusicXrayApi::Track.find :all
      #puts t.inspect
      f =  t.first
      f.recalcfeatures = true
      f.save
      f.reload
      puts f.inspect
    end
    
    should "be able to find all tracks that aren't extracted" do 
        @page = 0
        #puts MusicXrayApi::Track.find(:all, params=>{:page=>@page}).inspect
        #while(tracks = MusicXrayApi::Track.find(:all, :params=>{:page=>@page, :extracted=>false})) do
        #  puts @page
        #  puts "found #{tracks.size} tracks"
        #  if tracks.size <= 0 
        #    break
        #  end
        #  puts tracks.first.id
        #  puts tracks.last.id
        #tracks.each do |t|
        #  puts t.id
        #end
        #tracks = nil
        # @page +=1
        #end
        
        #while(track_match_requests = MusicXrayApi::TrackMatchRequest.find(:all,:params=>{:page=>@page,:limit=>50})) do 
        #  puts @page
        #  puts "found matches #{track_match_requests.size}"
        #  if track_match_requests.size <= 0
        #    break
        #  end
        #  puts track_match_requests.first.id
        #  puts track_match_requests.last.id
        #  @page+=1
        #end
        #@trm = MusicXrayApi::TrackMatchRequest.find(:all,:params=>{:limit=>1}).first
        #@trm.put(:rematch)
        #@trm.inspect
    end
    should "be able to create track and find it later" do 
      time = Time.now.to_i.to_s
      t1 = MusicXrayApi::Track.create({:mp3_url=>"http://www.google.com", 
                                       :uri=>"xray/#{Time.now.to_i.to_s}12", 
                                       :application_name=>'myxrays', 
                                       :application_id=>"#{time}"})
      #puts t1.inspect                                  
      tracks = MusicXrayApi::Track.find :all, :params=>{:application_name=>'myxrays', :application_id=>time}
                   
    end
  end
end


