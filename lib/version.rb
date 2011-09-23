require 'httparty'

class Version
  include DataMapper::Resource
  include HTTParty

  property :version,    String
  property :commit_sha, String
  property :created_at, DateTime, :key => true

  base_uri 'https://api.github.com'
  default_params :output => 'json'
  format :json

  def self.get_versions
    # get the maint sha
    maint_sha = get("/repos/gitster/git/git/refs/heads/maint").parsed_response['object']['sha']

    # list commits in maint until we find the most recent release
    commits = get("/repos/gitster/git/commits", :query => {:sha => maint_sha}).parsed_response
    commits.each do |commit|
      message = commit['commit']['message'].split("\n").first
      if m = /^Git (.*?)$/.match(message)
        version = m[1]
        p commit['sha']
        if !Version.first(:version => version)
          v = Version.new
          v.version = version
          v.commit_sha = commit['sha']
          v.created_at = commit['commit']['author']['date']
          if v.save
            puts "Version #{version} saved"
          else
            puts "Version #{version} save failed"
          end
        end
      end
    end
  end

end

