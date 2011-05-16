require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'yaml'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))


require 'music_xray_api'

class Test::Unit::TestCase
  
  #YAML.load_file("./test/credentials.yml").each { |key,value| instance_variable_set("@#{key}", value) }
end