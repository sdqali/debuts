require 'rubygems'
require 'json'
require File.dirname(__FILE__) + '/parse.rb'
require File.dirname(__FILE__) + '/fetch.rb'



include Parser
include Fetcher
def generate(country, list)
  players = parse(list)
  players.each do |p|
    begin
      record = fetch(p[:name], country)
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      next
    end
    p.merge! record
    p.merge! :country => country
    puts p.to_json
  end
  IO.write("./data/#{country}_dataset", players.to_json)
  teardown
end

puts "*" * 80
puts "Fetching Pakistani players"
generate "Pakistan", "./data/list_of_pakistani_players"
puts "*" * 80
puts "Fetching Indian players"
generate "India", "./data/list_of_Indian_players"
