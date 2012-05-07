require "selenium-webdriver"

module Fetcher
  def fetch(player, country)
    pl = player.gsub(" ", "+")
    driver.navigate.to "http://stats.espncricinfo.com/guru?sdb=find&search=#{pl}&.submit=Search"
    driver.find_element(:link_text, "Test Player").click
    team_element = driver.find_element(:name, "team")
    team_element.send_keys country if team_element.displayed?
    driver.find_elements(:name, "viewtype")[4].click
    driver.find_element(:name, ".submit").click
    data = driver.find_elements(:tag_name, "PRE").first.text.downcase
    boundary = "series         win   mat  runs  hs   batav 100  50   w    bb  bowlav 5w  ct st"
    splits = data.split(boundary)
    relevant = splits[1].strip
    series = relevant.split("\n")[0]
    result = relevant.split("\n")[1].strip 
    winner = result.split(" ").first.strip
    figures = result.split(" ")[1..-1]
    headers = ["Mat", "Runs", "HS", "BatAv", "100s", "50s", "W", "BB", "BowlAv", "5w", "Ct", "Ct"]
    performance = Hash[headers.zip figures]
    {
      :series => series,
      :winner => winner,
      :series => series,
      :performance => performance
    }
  end

  def driver
    @@DRIVER ||= Selenium::WebDriver.for :firefox
  end

  def teardown
    driver.quit
  end
end
