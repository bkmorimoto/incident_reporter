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
    ip_address = open('http://whatismyip.akamai.com').read
    zip_code = Geocoder.search(ip_address)[0].data["zip_code"].to_i
    get_zip_return_complaints
    quit_yes_or_no
  end

  def get_zip_return_complaints
    puts "Welcome to your personal NYC complaint finder. Want to find all complaints near you?"
    puts "Enter your zip code"
    zip_code = user_input
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
