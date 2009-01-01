class Author
	
	def self.all
		authors =  File.join(RAILS_ROOT, 'config/authors.txt')
    if File.exists?(authors)
      authors = File.readlines(authors)
      @authors = {:main => [], :contrib => []}
      authors.each do |author|
        data = author.split(' ')
        number = data.pop.gsub('(', '').gsub(')', '').chomp
        name = data.join(' ')
        if(number.to_i > 50)
          @authors[:main] << [name, number.to_i]
        else
          @authors[:contrib] << [name, number.to_i]
        end
      end
    end
		@authors
	end
	
end