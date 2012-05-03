require 'rubygems'
require 'nokogiri'
require 'csv'

doc = Nokogiri::HTML IO.read("./data/list_of_indian_players")

data = doc.search('tr')[2..-1].map do |tr|
  tds = tr.search('td')
  {
    :cap => tds[0].text.to_i,
    :name => tds[1].text,
    :debut_year => tds[2].text.to_i
  }
end

puts data.inspect
