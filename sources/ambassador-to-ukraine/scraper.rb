#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Appointed'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name type title start _ end].freeze
    end

    field :title do
      tds[3].text.tidy
    end

    def empty?
      tds[0].text == tds[3].text
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
