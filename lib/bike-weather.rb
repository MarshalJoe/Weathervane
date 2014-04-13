require 'rubygems'
require 'bundler/setup'
require 'json'
require 'rest-client'
require 'forecast_io'
require 'typhoeus/adapters/faraday'
require 'foreman'
require 'twilio-ruby'
require 'crack'
require 'date'

class BikeWeather
  attr_accessor :weather_lat, :weather_lng, :twilio_client, :message, :weather_data, :rain
  
  def initialize(geo_object)
    @weather_lat = geo_object.lat
    @weather_lng = geo_object.lng
    @message = 'WRONG'
    @wind = ""

    ForecastIO.api_key = "ff0b5095860089275dacb1ccfe58dbc4"
    account_sid = "AC2272c71148bb16716f4ec4f93da932f7"
    auth_token = "77bfd98845350e2f45acf4bbd87a6b99"
    @weather_data = ForecastIO.forecast(@weather_lat, @weather_lng)
    @twilio_client = Twilio::REST::Client.new account_sid, auth_token
  end

# This method sends a GET request to the forecast.io API to receive a timezone for Austin 
#
# Receives no arguments
#
# Returns "Your timezone is (Austin's timezone)"

  def rain_chance
    new_array = client.weather_data["hourly"]["data"].find_all {|r| r["precipProbability"] > 0}
    first_rain = new_array[0]
    time_of_rain = first_rain["time"]
    datetime_rain = Time.at(time_of_rain).to_datetime
    now = Time.now
    time_til_rain_seconds = time_of_rain.to_i - now.to_i
    time_til_rain_hours = time_til_rain_seconds / 3600
    rain_intensity = first_rain["precipIntensity"]
  end


  def rain_hours
    #array_moderate_hours = []
    #array_heavy_hours = []
    rain_hours = []

    weather_data = @weather_data["daily"]["data"][0]

    if weather_data.has_value?('rain')
      hourly_weather_data = @weather_data["hourly"]["data"]

      hourly_weather_data.each do |item|
        # if the precipIntensity is between .1 & .4 rainfall is moderate
        if item.precipIntensity >= 0.00001 #&& item.precipIntensity < 0.4
          time = DateTime.strptime(item.time.to_s,'%s')
          rain_hours << time
          #puts 'added'
        end
      end
    end

    rain_hours
  end


  def get_rain_time
    time_array = []
    rain_hours = rain_hours()
    rain_hours.each do |timestamp|
      #puts timestamp.strftime("on %m/%d/%Y at %I:%M%p") 
      date_today = Time.now.strftime("%d")
      timestamp_day = timestamp.strftime("%d") #at %I:%M%p
      #puts "#{date_today} #{timestamp_day}"
      # if the day today is the same as the timestamp day
      if date_today == timestamp_day
      time_array << timestamp.strftime("%I:%M%p")
      end
    end
    time_array
  end

  def format_rain_time
    format_time_array = get_rain_time()
    time_string = ""
    format_time_array.each do |time|
      time_string = time_string + time + " "
    end

    if format_time_array.length >= 1
      time_string="There is a chance of rain at: #{time_string}."
    else
      time_string= ""
    end
  end

  def show_hashie_mash
    weather_data = @weather_data["hourly"]["data"]

    weather_data.each do |item|
      puts item 
    end
  end




  # def rain_data
  #   hourly = @weather_data["hourly"]

  #   hourly_data = @weather_data["hourly"]["data"]

  #   hourly_data_3 = @weather_data["hourly"]["data"][3]["precipProbability"]

  #   hourly_data_3_precip = @weather_data["hourly"]["data"][3]["precipProbability"]

  #   puts "hourly: #{hourly_data_3}"
  # end

  #hourly_data #{hourly_data} hourly_data_3 #{hourly_data_3} hourly_data_3_precip #{hourly_data_3_precip}" 
  #end



  def windy
    @wind_speed = @weather_data["currently"]["windSpeed"]
    if @wind_speed > 18
      @wind = "Watch out for high winds"
    else
    end
  end

  def visibility
    @visibility_number = @weather_data["currently"]["visibility"]
      # if @visibility_number < 1
      #   @visibility = "Also, current visibility is low."
      # end
  end

  def final_message
    times = format_rain_time()
    current_summary = @weather_data["currently"]["summary"].to_s
    @daily_summary = @weather_data["hourly"]["data"][0]["summary"].to_s
    @max_temp = @weather_data["daily"]["data"][0]["temperatureMax"].to_i.to_s
    @min_temp = @weather_data["daily"]["data"][0]["temperatureMin"].to_i.to_s
    @message = "Hi there! Today it's mainly #{current_summary.downcase}, with a high of " +
    @max_temp + " and a low of " + @min_temp + "." + "#{times}" #+ @rain  + @wind 
  end
end

class Geolatlng
  attr_accessor :lat, :lng

  def initialize(addr)
    @base_google_url = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address="
    @addr = addr
    @lat = nil
    @lng = nil
  end

  def get_coordinates_from_data
    res = RestClient.get(URI.encode("#{@base_google_url}#{@addr}"))
    parsed_res = Crack::XML.parse(res)
    @lat = parsed_res["GeocodeResponse"] ["result"] ["geometry"] ["location"] ["lat"]
    @lng = parsed_res["GeocodeResponse"] ["result"] ["geometry"] ["location"] ["lng"]
  end
end

weather_data = Geolatlng.new("Everett, Wasgington")
weather_data.get_coordinates_from_data
client = BikeWeather.new(weather_data)

#client.show_hashie_mash

client.format_rain_time
puts client.final_message

# client.rain_chance
# client.windy
# client.visibility

# client.final_message
# puts client.message

# @client.account.messages.create(
#   :from => '+1480-725-2453',
#   :to => '+18477021744',
#   :body => 'Hey there!'
# )

#geo_object = Geolatlng.new("64101")
#geo_object.get_coordinates_from_data
#bike_object = BikeWeather.new(geo_object)
#bike_object.send_message

