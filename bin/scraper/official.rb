#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

# TODO: allow ScraperData to use Cabinet here!
class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('h3').text.gsub(/Dr\. /, '').tidy
    end

    field :position do
      noko.css('h4').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

    def member_container
      noko.css('.module__persongrid .persongrid__item')
    end
  end
end

url = 'https://www.whitehouse.gov/administration/cabinet/'
puts EveryPoliticianScraper::ScraperData.new(url).csv
