require "rubygems"
require "bundler"
Bundler.setup

Bundler.require(:runtime)

require './app'

use Rack::Static, :root => "public"

run GitApp

