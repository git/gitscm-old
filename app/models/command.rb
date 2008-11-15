class Command < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :examples
  
  def clean_usage
    usage.gsub('[verse]', '')
  end
  
  def has_examples?
    false
  end
  
  def has_book_chapters?
    false
  end
  
  def has_manual_pages?
    false
  end
  
  def level
    if porcelain_flag
      'porcelain' 
    else
      'plumbing'
    end
  end
  
  def full_command
    if command[0, 3] != 'git'
      ['git', command].join(' ')
    else
      command
    end
  end
  
end
