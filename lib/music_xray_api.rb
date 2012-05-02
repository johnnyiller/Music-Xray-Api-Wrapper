require 'net/https'
require 'uri'
require 'time'
require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "rubygems"
#require "mail"
#require "xmlsimple"
#gem 'activesupport', '2.3.5'
#gem 'activeresource', '2.3.5'
#require 'activesupport'
#begin
#  require 'activeresource'
#rescue
#  require 'active_resource'
#end


$:.unshift(File.dirname(__FILE__))
require 'music_xray_api/base'
require 'music_xray_api/track'
require 'music_xray_api/track_set'
require 'music_xray_api/track_set_member'
require 'music_xray_api/track_match_request'

