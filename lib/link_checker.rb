#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'label_reader'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

class LinkData

  def initialize
    puts "start link_checker.rb"
    @arraylist = Make_List.new
    @runlist = []
    @jsonarr = []
  end

  def get_linkinfo(filename)
    companylist_path = "./read/linklist_#{filename}"
    list = @arraylist.get_companies_from_file(companylist_path)
    @runlist = list
    puts @runlist
#    @runlist.each_with_index do |company, index|
#      filepath = "./export/CB/json/#{company}_CB.json"
#      puts "FILE LOCATION #{filepath}"
#      if File.exist?(filepath) then
#        puts "FILE EXISTS IN DIRECTORY"
#        obj = @CB_jsonreader.read_JSON_file(company, filepath)
#      elsif
#        obj = self.get_CBcompanyinfo_from_domain(filename, key_made, company)
#        puts
#        puts
#      end
#      json_info = obj.to_json
#      puts json_info
#      puts "HERE IS THE JSON INFO"
#      @jsonarr << json_info
#      puts @jsonarr
#      puts "MATH"
#      #testone = @jsonreader.cycle_through(bear)
#      puts "TEST 2:#{@jsonarr}"
#      puts "DONE #{company} for #{index}"
#    end
#    puts "ALL ABOARD"
#    puts @jsonarr
#    @jsonarr.each_with_index do |company, index|
#      puts "***"
#      puts "DATA : #{company} & #{index}"
#      puts "***"
#    end
#    listings = @jsonarr
#    testone = @CB_jsonreader.cycle_through(listings, filename)
#    puts testone
#    puts
#    puts
#    puts "COMPLETE saved in #{filename}"
#    puts key_made
  end
end
