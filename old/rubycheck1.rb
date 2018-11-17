#! /usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
#
#files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
#Dir.glob(files).each do |file|
#  require file
#end

class Sitecheck

  def initialize
    info = {}
    self.set_info(info)
    linklist = self.get_links(info)
    self.read_links(linklist, info)
    #self.testme

  end

  def set_info(info)
    info[:file_path] = "./read/"
    info[:file_name] = "speakerlist_all"
    info[:sitetype] = "DevLearn_speakers"
    # set information to use for file
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
      exit
    end
  end

  def fetch(file_name, url)
    value = %x( wget --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" "#{url}" -O #{file_name} )
    file = nil
    if value
      file = open(file_name)
    end
    page = nokgoget(file)
    page = nokoh3(file)
    puts "DONE"
  end

  def nokgoget(page)
    doc = Nokogiri::HTML(page)
    doc.css('p').each do |p|
      puts p.parent.attr('class')
      puts p
    end
  end

  def nokoh3(page)
    doc = Nokogiri::HTML(page)
    puts "PAGE#####{page}"
    doc.css('h3.r a.l').each do |link|
      puts link.html
      puts "####"
    end
    jp = doc.at_css('h3').html
    puts jp
  end

  def testme(item, sitetype)
    #host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"
    host = item
    ending = host[-4..-1]
    puts host
    puts ending
    testfile = fetch("#{sitetype}_#{ending}.html", "#{host}")
    puts "test-#{testfile}"
  end
end

siteinfo = Sitecheck.new
#host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"

