require "rubygems"
require "bundler"
Bundler.setup

Bundler.require(:runtime)

require './app'

use Rack::Static, :urls => ["/css", "/images", "/js"], :root => "public"

run GitApp

