#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

#require_relative './lib/filename'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end
#
host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"


files = File.join(File.dirname(--FILE--))
require 'open-uri'
host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"

uri = open("#{host}")
#def fetch(file_name, url)
#  value = %x( wget --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" "#{url}" -O #{file_name} )
#  file = nil
#  if value
#    file = open(file_name)
#  end
#  file
#end

#host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"
#file = fetch("result.html", "#{host}")
puts file

