#! /usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/environment'
require 'pp'

class ManParser
  
  attr_reader :usage, :description, :sections
  
  def initialize(text)
    @lines = text.split("\n")
    @sections = {}
    parse
  end
  
  def usage
    @sections['synopsis'][1].join("\n").gsub("[verse]", '') rescue ''
  end

  def short_description
    @sections['name'][1].join(" ").split(' - ')[1] rescue ''
  end
  
  def links
  end
  
  def parse
    in_pre = false
    current_section = nil
    previous_line = ''
    previous_section = nil
    section_number = 0
    
    @lines.each do |line|
      if line == '+'
        in_pre = !in_pre
      else
        if line[0, 3] == '---'
          if (!in_pre && (line.size == previous_line.size))
            section_number += 1
            current_section = previous_line.downcase
          end
          if previous_section
            @sections[previous_section][1].pop
          end
          next
        end
      end

      if current_section
        @sections[current_section] ||= [section_number, []]
        @sections[current_section][1] << line
      end
      
      
      previous_line = line
      previous_section = current_section
    end
    
  end
  
end

Dir.chdir($git_dir) do
  
  tags = `git tag`.split("\n")

  # go through all versions (reverse-order)
  first_tag = true
  tags.reverse.each do |tag|
    next if !tag.match(/v1\.(\d+)\.(\d+)/)
    relnotes = "Documentation/RelNotes-#{tag.gsub('v', '')}.txt"
    
    if File.file?(relnotes)
      tag_time = `git cat-file tag #{tag} | sed -n 's/^tagger.*> //p' | cut -d ' ' -f 1`.chomp
      tag_time = Time.at(tag_time.to_i)
      
      # get/create version
      if Version.find_by_version(tag)
        next
      end
      
      version = Version.find_or_create_by_version(tag)
      version.date = tag_time
      version.save
        
      puts 'importing ' + tag

      if first_tag
        # building category list
        $cats = {}
        categories = `git show #{tag}:command-list.txt`.gsub("\t", '  ').gsub(/( +)/, ' ').split("\n") rescue []
        categories = categories.select { |a| a.match(/^git/) }
        categories.each do |line|
          data = line.split(' ')
          command = data.shift.gsub('git-', '')
          $cats[command] = data
        end
      end
            
      lines = `git ls-tree #{tag}:Documentation`.split("\n")
      lines = lines.map { |line| line.split("\t") }
      lines = lines.select { |line| line[1].match(/git(.*?).txt/) }

      # go through all the man-pages (if not there)
      lines.each do |data, file|
        mode, type, sha = data.split(' ')
        manpage = ManParser.new(`git show #{sha}`)

        #puts "#{file} : " + manpage.size.to_s
        if gitcommand = file.match(/git(.*?).txt/)
          if gitcommand[1][0, 1] == '-'
            cmd = gitcommand[1][1, gitcommand[1].size]

            # get/create command
            if !(command = Command.find_by_command(cmd))
              command = Command.find_or_create_by_command(cmd)
              command.command = cmd
              command.clean_command = cmd.gsub(/[^a-zA-Z]/, '')
              command.description = manpage.short_description
              command.usage = manpage.usage
              command.porcelain_flag = $cats[cmd].include?('mainporcelain') rescue false
              command.save

              # link categories
              if cat = $cats[cmd]
                cat.each do |catname|
                  c = Category.find_or_create_by_category(catname)
                  command.categories << c if !command.categories.include?(c)
                  #rescue nil
                end
              end
              
              # !! TODO !! - add/update main example (from manpage)
            end
          end
          
          if !mp = Manpage.find_by_command_id_and_version_id(command.id, version.id)
            # add manpage w/ version
            mp = Manpage.new
            mp.command_id = command.id
            mp.version_id = version.id
            mp.save
            
            # split up by section / add each section
            manpage.sections.each do |name, data|
              pos, text = data
              mps = ManpageSection.new
              mps.manpage_id = mp.id
              mps.title = name
              mps.position = pos.to_i
              mps.text = text.join("\n")
              mps.save rescue nil
            end
          end rescue nil
        
          # add release notes
          relnote_data = File.read(relnotes)
          if !ReleaseNote.find_by_version_id(version.id)
            puts 'relnote'
            ReleaseNote.create(:version_id => version.id, :note => relnote_data)
          end rescue nil
          
        end
      end
      
      first_tag = false
      
    end
  end

  
  
end    
    
    