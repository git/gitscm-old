class DocFile
  include DataMapper::Resource
  has n, :docs
  property :id,          Serial
  property :name,        String, :length => 250, :key => true
end

class Doc
  include DataMapper::Resource
  belongs_to :doc_file
  belongs_to :doc_version
  property :id,          Serial
  property :doc,         Text
end

class DocVersion
  include DataMapper::Resource
  has n, :docs
  property :id,          Serial
  property :version,     String, :length => 250
  property :commit_sha,  String
  property :tree_sha,    String
  property :created_at,  DateTime
end
