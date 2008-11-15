class PageController < ApplicationController
	before_filter :get_version, :only => [:index, :download]
	caches_page :index, :about, :development, :documentation, :download, :tools

	def index
	end
  
  def searchbox
    @search = params[:search]
    search = @search.gsub(/[^a-zA-Z]/, '')
    
    # look for command
    @command = Command.find_by_clean_command(search)
    # else search man pages
    
    render :partial => 'searchbox'
  end
  
	def feed
		data = File.expand_path(File.dirname(__FILE__) + "/../../config/app_data.yml")
		@releases = YAML.load(File.read(data))
    headers["Content-Type"] = "text/xml"

    respond_to do |format|
      format.xml { render :template => 'page/feed.xml.builder', :layout => false }
    end
  end

	def about
		@authors = Author.all
	end

	private
	def get_version
		version_file = File.expand_path(File.dirname(__FILE__) + "/../../config/app_config.yml")
		config = YAML.load(File.read(version_file))
		@version = config['latest_version']['version']
		@date = Time.at(config['latest_version']['ts'].to_i).strftime("%Y-%m-%d")
	end
end