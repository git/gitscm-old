require "open-uri"

class Repository
	     		    
	attr_accessor :user, :repo, :description  
	
	def initialize(data)
		@user = data[:user]
		@repo = data[:repo]
		@description = data[:description]
	end
	
	def url_for_user
		"http://github.com/#{self.user}"
	end
	
	def url_for_project
		"http://github.com/#{self.user}/#{self.repo}/tree"
	end	
		
end   

class << Repository
	
	def featured 
		data = {}
		data[:user] = (dom/".featured/.site/.meta/.user/a").inner_html 
		data[:repo] = (dom/".featured/.site/.meta/.repo/a").inner_html
		data[:description] = (dom/".featured/.site/.blurb").inner_html		
		
		object = Repository.new(data)    
		object
	end
	
	def dom
		@dom ||= Hpricot(open("http://github.com"))
		@dom
	end             
	
end