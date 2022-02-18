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
      %w[district name party notes].freeze
    end

    def raw_start
      match = /Appointed (.*)/
      return '11 January, 2021' unless notes =~ match

      $1
    end

    def raw_end
      match = /(?:Resigned|Died) (.*)/
      return unless notes =~ match

      $1
    end

    def notes
      tds[3].text.gsub('Appointed to Arizona Senate', 'Resigned').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
