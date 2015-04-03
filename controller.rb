require_relative 'report_model.rb'
require 'geocoder'
require 'socket'

# requ ire_relative 'view'

class Controller
  def initialize
    @data = Report.new
    # @view = View.new
  end

  def run
    get_zip_return_complaints
    quit_yes_or_no
  end

  def get_zip_return_complaints
    puts "Welcome to your personal NYC complaint finder. Want to find all complaints near you?"
    puts "Search complaints by IP Address or by zip code"
    puts "Enter 'IP' or 'ZIP'"
    answer = user_input.upcase
    case answer
    when "IP"
      ip_address = open('http://whatismyip.akamai.com').read
      zip_code = Geocoder.search(ip_address)[0].data["zip_code"].to_i
      puts "Searching complaints for zip code: #{zip_code}"
    when "ZIP"
      puts "Enter your zip"
      zip_code = user_input
    else
      puts "Did not recognize your input"
      get_zip_return_complaints
    end
    @data.jeopardy
    @data.report_by_zip_code(zip_code)
    @data.kill_jeopardy
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
