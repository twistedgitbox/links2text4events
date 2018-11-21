#! /usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'rubygems'
require 'bundler/setup'
require 'csv'
require 'yaml'
Bundler.require(:default)
#
#files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
#Dir.glob(files).each do |file|
#  require file
#end

class Site_LinkReader

  def initialize
    info = {}
    @info = {}
    puts info, @info
    puts "LINKREADER-INIT"
    #  self.set_info(info)
    #  linklist = self.get_links(info)
    #  self.read_links(linklist, info)
    #self.testme
    #self.fill_speakergroup(info)
    #self.set_site(info)
  end

  def link_list_run(filename, template_path)
    puts "FILE #{filename}"
    puts "READERFILE #{template_path}"
    puts "DONE WITH LINKLIST"
    @from_file = YAML.load_file("#{template_path}")
    puts @from_file[:sitetype]
    puts @from_file[:file_name]
    info = {}
    @info = {}
    @savefile = filename
    self.set_site(info)
  end

  def set_site(info)
    site_type = "devlearn_speakers"
    puts @from_file[:sitetype]
    site_type = @from_file[:sitetype]
    #site_type = "devlearn_sessions"
    puts site_type

    ##case site_type
    ##when "devlearn_speakers"
    ##  self.devlearn_speaker_info(site_type)
    ##when "devlearn_sessions"
    ##  self.devlearn_session_info(site_type)
    ##else
    ##  puts "NO VIABLE TEMPLATE"
    ##  exit
    ##end
    #self.devlearn_speaker_info(site_type)
    #self.devlearn_session_info(site_type)
    info = self.get_info(site_type)
    self.fill_speakergroup(info)
    puts info
    puts @info
    puts @group
    puts "WHAT NEXT?"
  end

  def fill_speakergroup(info)
    #self.set_info(info)
    linklist = self.get_links(info)
    self.read_links(linklist, info)
    puts "FIN ######### FIN ######## FIN "
    puts
    puts @group
    puts @group.count
    self.arrayhash2file
    #self.testme
  end

  def arrayhash2file(csv_filename = "./export/#{@info[:sitetype]}_collection.csv")
    puts "SAVEFILE - #{@savefile}"
    savefilename = @savefile
    ourtime = self.get_ourtime
    csv_filename = "./export/#{@info[:sitetype]}_#{savefilename}_#{ourtime}.csv"
    group = @group
    puts group
    CSV.open(csv_filename, "wb") do |csv|
      keys = @group.first.keys
      # header_row
      csv << keys
      @group.each do |hash|
        csv << hash.values_at(*keys)
      end
    end
  end

  def devlearn_speaker_info(site_type)
    puts "MISSION-PRE:#{site_type}"
    set_options = {
      file_path: "./read/",
      file_name: "shortspeakerlist_all",
      sitetype:  "#{site_type}",
      #speaker_container: ".speaker-container"
      label0: ".speaker-container",
      label1: "NONE",
      label2: "NONE",
      label3: "NONE",
      label4: "NONE",
      label5: "NONE",
      label6: "NONE"
    }
    puts set_options
    puts "MISSION: #{site_type}"
    File.write("./options/#{site_type}.yml",set_options.to_yaml)
  end

  def devlearn_session_info(site_type)
    puts "MISSION-PRE:#{site_type}"
    set_options = {
      file_path: "./read/",
      file_name: "shortsessionlist_all",
      sitetype:  "#{site_type}",
      label0: ".session-details",
      label1: ".sessman",
      label2: ".time",
      label3: "session-info",
      #label3: ".col// track",
      label4: ".session-description",
      label5: ".speaker-name",
      label6: ".speaker-bio"
    }
    puts set_options
    puts "MISSION: #{site_type}"
    File.write("./options/#{site_type}.yml",set_options.to_yaml)
  end

  def get_info(site_type)
    info = {}
    from_file = YAML.load_file("./options/#{site_type}.yml")
    info[:file_path] = from_file[:file_path]
    info[:file_name] = from_file[:file_name]
    info[:sitetype] = from_file[:sitetype]
    # set information to use for file
    @info = {
      #speaker_container: from_file[:speaker_container],
      sitetype: from_file[:sitetype],
      label0: from_file[:label0],
      label1: from_file[:label1],
      label2: from_file[:label2],
      label3: from_file[:label3],
      label4: from_file[:label4],
      label5: from_file[:label5],
      label6: from_file[:label6]
    }
    @group = []
    puts info[:file_path]
    puts info[:file_name]
    puts info[:sitetype]
    puts @info[:speaker_container]
    return info
  end

  def get_links(info)
    file_path = info[:file_path]
    file_name = info[:file_name]
    puts file_path
    puts file_name
    linklist = File.readlines("#{file_path}#{file_name}")
    puts linklist
    puts linklist.count
    return linklist
  end

  def read_links(linklist, info)
    sitetype = info[:sitetype]
    linklist.each do |item|
      puts "ITEM - #{item}"
      self.testme(item, sitetype)
    end
  end

  def fetch(file_name, url)
    puts "FILE IS #{file_name}"
    value = %x( wget --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" "#{url}" -O #{file_name} )
    file = nil
    unless value.nil? || value == 0 then
      puts "SAVING #{file_name} NOW"
      file = open(file_name)
      puts "*****"
      puts value
      puts "****"
    end
    # get article info collects the title and items like title and bio
    page = get_article_info(file_name)
    #    puts "DONE"
  end

  def get_article_info(file_name)
    # Gather the information from your speaker sites and then save in a hash which is saved in the @group array
    unit_set = []
    title = get_title(file_name)
    hgroup3 = get_headers(file_name)
    unit_info = get_bio(file_name)
    puts "TITLE - #{title}"
    puts "INFO - #{unit_info}"
    puts "UNIT DONE"
    puts unit_info.class
    unit_info["TITLE"] =  "#{title}"
    puts unit_info
    puts "ADDING..."
    @group << unit_info
    puts @group
  end

  def para_get(page)
    puts page
    file = File.read("./#{page}")
    doc = Nokogiri::HTML(file)
    doc.css('p').each do |p|
      #puts p.parent.attr('class').text
      puts p.text
    end
  end

  def get_title(page)
    file = File.read("./#{page}")
    puts page
    grab = []
    doc = Nokogiri::HTML(file)
    puts "PAGE##TITLE###{page}"
    doc.xpath('//title').each do |node|
      grab << node.text
    end
    puts "TITLE #{grab}"
    title = grab[0]
    puts title
    return title
  end

  def get_paragraphs(page)
    file = File.read("./#{page}")
    puts page
    grab = []
    doc = Nokogiri::HTML(file)
    puts "PAGE##PAR###{page}"
    doc.xpath('//p').each do |node|
      puts node.text
      grab << node.text
    end
  end

  def get_headers(page)
    puts page
    file = File.read("./#{page}")
    grab = []
    doc = Nokogiri::HTML(file)
    puts "PAGE##HEAD###{page}"
    doc.xpath('//h3').each do |node|
      puts node.text
      grab << node.text
    end
  end

  def get_bio(page)
    puts page
    file = File.read("./#{page}")
    grab = []
    bio_group = {}
    doc = Nokogiri::HTML(file)
    puts "PAGE##BIO###{page}"
    #cat_type = ".speaker-container"
    #cat_type = @info[:speaker_container]
    #rabbit
    puts @info.count
    #
    @info.each_with_index do |(ky, val), idx|
      puts ky, idx
      unless ky == "sitetype" || val == "NONE"
        puts "MADE IT"
        cat_type = val
        puts "#{idx}: #{ky} => #{val}"
        puts cat_type
        cat_label = "#{val}:"
        cat_label.upcase!
        puts cat_label, ky
        #exit
        doc.css("#{cat_type}").each do |n|
          precontent_text = n.content
          precontent_text.gsub!("\n",'|--|')
          puts precontent_text
          content_text = "#{cat_label}:#{precontent_text}"
          #content_arr = content_text.split("\n")
          content_arr = []
          content_arr << content_text
          puts content_arr.class
          content_arr.reject! { |e| e.to_s.empty? }
          puts "CONTENT:::"
          puts content_arr
          unless content_arr.empty?
            content_arr.each_with_index do |value, index|
              puts "LABEL FOR CONTENT #{index} is #{value}"
              bio_group["GLABEL#{val}-#{index}"] = value
            end
          end
        end
      end
    end
    puts bio_group
    grab << bio_group
    puts "article group - "
    puts grab.count
    return bio_group
  end

  def get_ourtime
    utime = Time.new
    ourtime = utime.strftime("%Y-%m-%d").to_s
    puts ourtime
    puts ourtime.class
    puts ourtime
    return ourtime
  end

  def testme(item, sitetype)
    #host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"
    host = item
    #host.gsub!(/\r/,"")
    #host.gsub!(/\n/,"")
    host.strip!
    ending = host[-4..-1]
    ending.strip!
    ourtime = self.get_ourtime
    puts ourtime
    puts host
    puts ending
    testfile = fetch("#{sitetype}_#{ending}.html", "#{host}")
    puts "test-#{testfile}"
  end

end

siteinfo = Site_LinkReader.new

