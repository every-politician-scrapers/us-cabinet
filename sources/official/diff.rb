#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

class UnitedStatesComparison < EveryPoliticianScraper::DecoratedComparison
  def wikidata_csv_options
    { converters: [->(v) { v.to_s.gsub(/^United States /, '').gsub(' of the United States', '') }] }
  end

  def external_csv_options
    { converters: [->(v) { v.to_s.gsub(/^United States /, '').gsub(' of the United States', '') }] }
  end
end

diff = UnitedStatesComparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
