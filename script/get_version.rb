#! /usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'chronic'
require 'yaml'
require 'pp'

version_file = File.expand_path(File.dirname(__FILE__) + "/../config/app_config.yml")

current_version = nil
if File.exists?(version_file)
  config = YAML.load(File.read(version_file))
  current_version = config['latest_version']['version']
end

url = 'http://kernel.org/pub/software/scm/git/'

agent = WWW::Mechanize.new
get_page = agent.get(url)

versions = []

regex = /<a href="git-([\d\.]*).tar.bz2">git-([\d\.]*).tar.bz2<\/a> (.*) ([\d\.]+[MK])/
matches = get_page.body.scan(regex)
matches.each do |match|
  versions << [Time.parse(match[2].strip), match[1], match[3]]
end

latest = versions.sort.reverse.shift

latest_version = latest[1]
if latest_version != current_version
  data = {'latest_version' => {'version' => latest[1], 'ts' => latest[0].to_i}}
  File.open(version_file, 'w') { |f| f.write(data.to_yaml) }
end
