class PageController < ApplicationController
  before_filter :get_version, :only => [:index, :download]
  caches_page :index, :about, :development, :documentation, :download, :tools
  
  def index
  end
  
  def about
    authors =  File.join(RAILS_ROOT, 'config/authors.txt')
    if File.exists?(authors)
      authors = File.readlines(authors)
      @authors = {:main => [], :contrib => []}
      authors.each do |author|
        data = author.split(' ')
        puts number = data.pop.gsub('(', '').gsub(')', '').chomp
        name = data.join(' ')
        if(number.to_i > 50)
          @authors[:main] << [name, number.to_i]
        elsif (number.to_i >= 5)
          @authors[:contrib] << [name, number.to_i]
        end
      end
    end
  end
  
  def get_version
    version_file = File.expand_path(File.dirname(__FILE__) + "/../../config/app_config.yml")
    config = YAML.load(File.read(version_file))
    @version = config['latest_version']['version']
    @date = Time.at(config['latest_version']['ts'].to_i).strftime("%Y-%m-%d")
  end
end