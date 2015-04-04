require_relative 'report_model.rb'
require 'geocoder'
require 'socket'

class Controller
  attr_reader :data

  def initialize
    @data = Report.new("https://data.cityofnewyork.us/resource/erm2-nwe9.json")
  end

  def run
    pick_report_field
    # get_zip_return_complaints
    quit_yes_or_no
  end

  def pick_report_field
    puts "Here are the fields to choose from:"
    data.field_map.keys.map {|field| print "#{field}  "}
    print "\nWhich field would you like to report on? "
    field = gets.chomp.capitalize
    print "\nFilter where #{field} = "
    value = gets.chomp
    print "\nAnd group by which field? "
    group_by = gets.chomp.capitalize
    data.report_any(data.field_map[field], value, data.field_map[group_by])
  end

  def get_zip_return_complaints
    puts "Welcome to your personal NYC complaint finder. Want to find all complaints near you?"
    puts "Search complaints by IP Address or by zip code"
    puts "Enter 'IP' or 'ZIP'"
    answer = user_input.upcase
    case answer
    when "IP"
      ip_address = open('http://whatismyip.akamai.com').read
      lat = Geocoder.search(ip_address)[0].data["latitude"]
      long = Geocoder.search(ip_address)[0].data["longitude"]
      zip_code = Geocoder.search("#{lat},#{long}")[0].data["address_components"][8]["long_name"].to_i
      puts "Searching complaints for zip code: #{zip_code}"
    when "ZIP"
      puts "Enter your zip"
      zip_code = user_input
    else
      puts "Did not recognize your input"
      get_zip_return_complaints
    end
    # @data.jeopardy
    # @data.report_by_zip_code(zip_code)
    # @data.kill_jeopardy
    @data.report_any(:descriptor,"Graffiti",:incident_zip)
  end

  def quit_yes_or_no
    puts "Do you want to find more complaints? Please answer 'yes' or 'no'"
    command = user_input
    case command
    when "yes" then run
    when "no" then puts "Goodbye!"
    else quit_yes_or_no
    end
  end

  def user_input
    gets.chomp
  end

end
