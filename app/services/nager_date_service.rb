require 'httparty'

class NagerDateService
  include HTTParty

  def self.next_holidays
    year = 2023
    country_code = 'US'
    response = HTTParty.get("https://date.nager.at/api/v3/PublicHolidays/#{year}/#{country_code}")
    holidays = JSON.parse(response.body)

    holidays.select do |holiday| 
      Date.parse(holiday['date']) > Date.today 
    end.first(3)
  end
end