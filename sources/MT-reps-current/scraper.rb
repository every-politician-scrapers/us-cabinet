#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Representative'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[district name party _ start].freeze
    end

    def raw_start
      super.gsub(/\(.*?\)/, '').tidy
    end

    def raw_end
      nil
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
