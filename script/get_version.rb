#! /usr/bin/env ruby
require 'rubygems'
require 'yaml'
require 'pp'

version_file = File.expand_path(File.dirname(__FILE__) + "/../config/app_config.yml")
data_file = File.expand_path(File.dirname(__FILE__) + "/../config/app_data.yml")

#perm_file = "/u/apps/gitscm/shared/config/app_config.yml"
#perm_data = "/u/apps/gitscm/shared/config/app_data.yml"
#git_dir = '/home/git/git'

perm_file = "/tmp/app_config.yml"
perm_data = "/tmp/rel_data.yml"
git_dir = '/Users/schacon/projects/git'

current_version = nil
if File.exists?(version_file)
  config = YAML.load(File.read(version_file))
  current_version = config['latest_version']['version']
end

ver = nil
time = nil
tag_array = []

Dir.chdir(git_dir) do
  ver = `git describe origin/maint | cut -d - -f 1`.chomp
  time = `git cat-file tag #{ver} | sed -n 's/^tagger.*> //p' | cut -d ' ' -f 1`.chomp
  tags = `git tag`.split("\n")
  tags.each do |tag|
    relnotes = "Documentation/RelNotes-#{tag.gsub('v', '')}.txt"
    if File.exists?(relnotes)
      tag_time = `git cat-file tag #{tag} | sed -n 's/^tagger.*> //p' | cut -d ' ' -f 1`.chomp
      tag_time = Time.at(tag_time.to_i)
      now = Time.now
      days = ((now - tag_time) / 60 / 60 / 24) rescue 99
      if days < 90
        tag_array << [tag_time, tag, File.read(relnotes)]
      end
    end
  end
end

ver = ver.gsub(/^v/, '') 

if (ver != current_version)
  puts "UPDATING to #{ver}"
  data = {'latest_version' => {'version' => ver, 'ts' => time.to_i}}
  File.open(version_file, 'w') { |f| f.write(data.to_yaml) }
  File.open(data_file, 'w') { |f| f.write(tag_array.to_yaml) }
  File.open(perm_file, 'w') { |f| f.write(data.to_yaml) } if File.exists?(perm_file)
  File.open(perm_data, 'w') { |f| f.write(tag_array.to_yaml) } if File.exists?(perm_data)
  `rm /u/apps/gitscm/current/public/index.html`
  `rm /u/apps/gitscm/current/public/download.html`
  `rm /u/apps/gitscm/current/public/feed.html`
end

