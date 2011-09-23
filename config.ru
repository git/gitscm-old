require "rubygems"
require "bundler"
Bundler.setup

Bundler.require(:runtime)

require './app'

use Rack::Static, :urls => ["/favicon.ico", "/favicon.png", "/robots.txt", "/blueprint", "/docs", "/stylesheets", "/images", "/javascripts"], :root => "public"
run GitApp

