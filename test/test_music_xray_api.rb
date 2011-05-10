require 'helper'

class TestMusicXrayApi < Test::Unit::TestCase
  context "Has valid credentials" do 
    setup do 
      YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
    end
    should "Be able to create a track." do
      threads = []
      10.times do 
        threads << Thread.new do
          MusicXrayApi::Tracks.create(@secret,@key).body
        end   
      end
      threads.each { |aThread|  aThread.join }
    end
  end
end
