#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end


require 'nokogiri'
require 'open-uri'
require 'mechanize'

#fail("Usage: extract_links URL [URL ...]") if ARGV.empty?

page_url = "https://www.elearningguild.com/devlearn/sessions/?selection=doc.5453&event=610"

mechanize = Mechanize.new

page = mechanize.get(page_url)

linkarr = []
page.links.each do |link|
  linkarr.push(link.href)
end

puts linkarr

File.open("./convert/raw_links", "w+") do |f|
  linkarr.each { |element| f.puts(element) }
end
#agent = Mechanize.new
#page = agent.get("#{page_url}")
#
#page.links_with(:href => /^https?/).each do |link|
#  puts link.href
#end

#ARGV.each do |url|
#  doc = Nokogiri::HTML(open(url))
#  hrefs = doc.css("a").map do |link|
#    if (href = link.attr("href")) && !href.empty?
#      URI::join(url, href)
#    end
#  end.compact.uniq
#  STDOUT.puts(hrefs.join("\n"))
#end
