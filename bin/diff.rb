#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

class UnitedStatesComparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(v) { v.gsub(/^United States /, '').gsub(' of the United States', '') }] }
  end
end

diff = UnitedStatesComparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r.last.to_s] }.reverse.map(&:to_csv)
