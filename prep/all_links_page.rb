#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'


class GetPageLinks
  # What does this do?
  # It uses nokogiri to go to a webpage and then extract all the links from the page. So you don't have to click through every link to get the information you need on (in this case) speaker bios.
  # All you need to do is set the site information (page, base and filename you want it to save itself as)
  # It will also add labels to links that are designated in the set label info method. That will make it easier to find the information you need or import it.
  def initialize

    # set variables here
    #
    # set filename
    # set page_site_info
    site_info = {}
    label_info = {}
    site_info = self.get_site_info(site_info)
    puts site_info.count
    label_info = self.get_label_info(label_info)
    puts label_info
    self.do_links(site_info, label_info)
  end

  def get_site_info(site_info)
    # The site_info is the hash containing information about the site you are scraping for links. Page site and base site should start the same.
    # This works on one site at a time. A later version will be created that can loop through a list of sites.
    site_info = {
      page_site: "https://www.elearningguild.com/devlearn/sessions/?selection=doc.5453&event=610",
      base_site: "https://www.elearningguild.com",
      file_name: "DevLearn_Sessions"
    }
    #
    return site_info

  end

  def get_label_info(label_info)
    # Place Label information here. Labels must be all caps.
    # The value is the beginning of the line that you want to prepend the label to
#    label_info[:SPEAKER] = "/devlearn/sessions/speaker-details"
#    label_info[:SESSION] = "/devlearn/sessions/session-details"
    label_info = {
      SPEAKER: "/devlearn/sessions/speaker-details",
      SESSION: "/devlearn/sessions/session-details"
    }

    puts label_info.keys[0]
    return label_info
  end

  def do_links(site_info, label_info)
    # Just testing to make sure we have the variables we need in the hashes
    file_name = site_info[:file_name]
    page_site = site_info[:page_site]
    base_site = site_info[:base_site]

    puts "Starting #{file_name} file. \n Scraping webpage at #{page_site} for #{base_site}"
    self.get_links(site_info, label_info)
    puts "Saved #{page_site} in #{file_name}"

  end

  def read_all_links(site_info, label_info)
    page_site = site_info[:page_site]
    base_site = site_info[:base_site]
    doc = Nokogiri::HTML(open("#{page_site}").read)
    raw_urls = doc.search('a', 'img').map{ |tag|
      case tag.name.downcase
      when 'a'
        tag['href']
      when 'img'
        tag['src']
      end
    }
    puts raw_urls
    raw_urls.reject! { |e| e.to_s.empty? }
    raw_urls.map!(&:to_s)
    urls = []
    raw_urls.each do |item|
      puts item
      if item.start_with?('#') then
        puts "nada"
      elsif item.start_with?('http', 'https') then
        puts "SPONSOR"
        sponsor = "SPONSOR: #{item}"
        urls.push(sponsor)
      elsif item.nil? then
        puts "NOTHING"
        #elsif item.start_with?(speaker_info) then
        #  puts "SPEAKER"
        #  puts speaker_info
        #  speaker = "SPEAKER: #{base_site}#{item}"
        #  urls.push(speaker)
      else
        label_info.each do |key, value|
          puts key
          puts value
          if item.start_with?(value) then
            label = "#{key}: #{base_site}#{item}"
            urls.push(label)
            item = "PUSHED"
          end
        end
        urls.push(item) unless item == "PUSHED"
      end
    end
    urls.push(base_site)
    return urls
  end

  def save_links(file_name, urls)
    puts "WRITING: #{urls}"
    f = File.new(file_name, 'w')
    File.open(file_name, "w+") do |f|
      urls.each { |element| f.puts(element) }
    end
    puts "SAVED IN #{file_name}"
  end

  def get_links(site_info, label_info)
    file_name = site_info[:file_name]
    # def get_links(file_name, page_site, base_site, speaker_info)
    urls = self.read_all_links(site_info, label_info)
    finder = self.save_links(file_name, urls)
    puts finder
  end


end

pageinfo = GetPageLinks.new

