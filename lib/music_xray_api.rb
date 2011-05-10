require 'net/https'
require 'uri'
require 'time'
require "cgi"
require "base64"
require "openssl"
require "digest/sha1"
require "rubygems"
require "mail"
require "xmlsimple"

$:.unshift(File.dirname(__FILE__))
require 'music_xray_api/base'
require 'music_xray_api/tracks'
#require 'amazon_ses/stats'
#require 'amazon_ses/amz_mail'