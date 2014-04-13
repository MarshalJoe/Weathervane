require 'rubygems'
require 'twilio-ruby'
require 'sinatra'

require_relative 'lib/bike-weather.rb'


get '/sms-quickstart' do  # you will respond to any get requests to this url with /sms-quickstart
  #new_text = BikeWeather.new('78723')
  user_input = params[:Body]
  new_text_message = Geolatlng.new(user_input)
  new_text_message.get_coordinates_from_data
  client = BikeWeather.new(new_text_message)
  message = client.final_message
  
  twiml = Twilio::TwiML::Response.new do |r|
     r.Message "#{message}"
   end
   
  twiml.text
  

  # twiml = Response.new
  # Message "hello #{message}"
  #sender = params[:Body]
  #sender = sender_hash.to_s
  #client.twilio_client

  
end