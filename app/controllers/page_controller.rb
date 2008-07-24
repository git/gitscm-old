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
        number, *name = author.split(' ')
        if(number.to_i > 50)
          @authors[:main] << [name.join(' '), number.to_i]
        else
          @authors[:contrib] << [name.join(' '), number.to_i]
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