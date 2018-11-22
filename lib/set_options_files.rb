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

class Set_Options

  def initialize
    info = {}
    @info = {}
    self.set_site(info)
  end

  def set_site(info)
    puts info
  end

  def devlearn_speaker_info(site_type)
    puts "MISSION-PRE:#{site_type}"
    set_options = {
      file_path: "./read/",
      file_name: "speakerlist_all",
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
    File.write("./options/#{site_type}_options.yml",set_options.to_yaml)
  end

  def devlearn_session_info(site_type)
    puts "MISSION-PRE:#{site_type}"
    set_options = {
      file_path: "./read/",
      file_name: "sessionlist_all",
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
    File.write("./options/#{site_type}_options.yml",set_options.to_yaml)
  end

end

setinfo = SetOptions.new

