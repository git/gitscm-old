class Example < ActiveRecord::Base
  has_and_belongs_to_many :commands
end
