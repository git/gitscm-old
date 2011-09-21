require 'sinatra'

require 'dm-core'
require 'dm-serializer/to_json'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'

## -- DATABASE STUFF --

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/local.db")

class Version
  include DataMapper::Resource
  property :version,    String
  property :current,    Boolean, :key => true
  property :created_at, DateTime
end

DataMapper.auto_upgrade!

class GitApp < Sinatra::Base

  def get_version
    @version = '1.7.6.1'
    @date = "2011-08-24"
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
