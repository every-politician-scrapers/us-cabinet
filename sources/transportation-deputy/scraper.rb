#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Name'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name start end].freeze
    end

    def raw_start
      super.gsub(/\(.*?\)/, '').tidy
    end

    def raw_end
      super.gsub(/\(.*?\)/, '').tidy
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv