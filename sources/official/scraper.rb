#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      noko.css('h3').text.gsub(/Dr\. /, '').tidy
    end

    def position
      noko.css('h4').text.tidy
    end
  end

  class Members
    def member_container
      noko.css('.module__persongrid .persongrid__item')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
