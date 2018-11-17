#! /usr/bin/env ruby
require 'open-uri'

#
#files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
#Dir.glob(files).each do |file|
#  require file
#end

class Sitecheck

  def initialize
    self.testme
  end

  def remove_html_tags(page)
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    #self.title.gsub!(re, '')
    page.gsub!(/(<[^>]*>)|\n|\t/s) {" "}
    newpage = page
    return newpage
  end

  def old_fetch(file_name, url)
    page = open(url).read
    newpage = self.remove_html_tags(page)
    puts "NEW: #{newpage}"
    puts "#{page.length} matches "
  end

  def fetch(file_name, url)
    value = %x( wget --user-agent="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36" "#{url}" -O #{file_name} )
    file = nil
    unless value.nil? || value == 0 then
      puts "SAVING #{file_name} NOW"
      file = open(file_name)
      puts
    end
    #page = get_article_info(file_name)
  end



  def testme
    # host = "https://www.elearningguild.com/devlearn/sessions/speaker-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&speaker=2531"
    host = "https://www.elearningguild.com/devlearn/sessions/session-details.cfm?event=610&fromselection=doc.5453&from=sessionslist&session=9507"
    puts host
    testfile = fetch("butter_result.html", "#{host}")
    puts "test-#{testfile}"
  end
end

siteinfo = Sitecheck.new

