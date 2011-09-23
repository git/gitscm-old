require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/local.db")

require 'lib/version'
require 'lib/doc'

DataMapper.auto_upgrade!
