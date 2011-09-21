source "http://rubygems.org"

gem "sinatra"
gem "dm-core"
gem "dm-serializer"
gem "dm-migrations"
gem "dm-validations"
gem "dm-timestamps"

group :production do
  gem "pg"
  gem "dm-postgres-adapter"
end

group :development do
  gem "sqlite3-ruby"
  gem "dm-sqlite-adapter"
  gem "shotgun"
end

