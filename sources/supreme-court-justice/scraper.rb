#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Justice'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name state position _ _ dates].freeze
    end

    field :position do
      tds[4].text.tidy
    end

    def raw_end
      super.gsub(/\(.*\)/, '').tidy
    end

    def empty?
      position.include? 'Chief'
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
