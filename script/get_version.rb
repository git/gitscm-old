#! /usr/bin/env ruby
require 'rubygems'
require 'yaml'
require 'pp'

version_file = File.expand_path(File.dirname(__FILE__) + "/../config/app_config.yml")
perm_file = "/u/apps/gitscm/shared/config/app_config.yml"

current_version = nil
if File.exists?(version_file)
  config = YAML.load(File.read(version_file))
  current_version = config['latest_version']['version']
end

git_dir = '/home/git/git'

ver = nil
time = nil

Dir.chdir(git_dir) do
  ver = `git describe origin/maint | cut -d - -f 1`.chomp
  time = `git cat-file tag #{ver} | sed -n 's/^tagger.*> //p' | cut -d ' ' -f 1`.chomp
end

ver = ver.gsub(/^v/, '') 

if ver != current_version
  puts "UPDATING to #{ver}"
  data = {'latest_version' => {'version' => ver, 'ts' => time.to_i}}
  File.open(version_file, 'w') { |f| f.write(data.to_yaml) }
  File.open(perm_file, 'w') { |f| f.write(data.to_yaml) } if File.exists?(perm_file)
  `rm /u/apps/gitscm/current/public/index.html`
  `rm /u/apps/gitscm/current/public/download.html`
end
