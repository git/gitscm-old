class Manpage < ActiveRecord::Base
  has_many :manpage_sections, :order => 'position'
  belongs_to :command
  belongs_to :version
  
  def sections
    manpage_sections.reject { |a| ['name', 'git'].include? a.title }
  end
  
  def options
    manpage_sections.find_by_title('options')
  end
  
end
