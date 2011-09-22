require 'sinatra'

require './lib/version'

class GitApp < Sinatra::Base

  def get_version
    v = Version.first(:order => [:created_at.desc])
    @version = v.version
    @date = v.created_at.strftime("%y-%m-%d")
  end

  get '/' do
    get_version
    erb :index
  end

  get '/course/:action' do
    @action = params[:action]
    @action.gsub!('.html', '')
    erb :"#{@action}", :layout => :course
  end

  get '/:action' do
    @action = params[:action]
    @action.gsub!('.html', '')
    get_version if @action == 'download'
    erb :"#{@action}"
  end

end
