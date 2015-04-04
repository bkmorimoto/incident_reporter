require 'open-uri'
require 'json'
require 'uri'
require 'soda'

class Report

  attr_reader :client, :table, :field_map

  def initialize(api_endpoint)
    uri = URI.parse(api_endpoint)
    @client = SODA::Client.new({:domain => uri.host})
    @table = /\/resource\/(.*).json/.match(uri.path)[1]
    @field_map = {
      "Created Date" => :created_date,
      "Type" => :complaint_type,
      "Description" => :descriptor,
      "Zip" => :incident_zip,
      "City" => :city,
      "Borough" => :borough
    }
  end

  # match_data =
  # domain =
  # @client = SODA::Client.new()
  # SODA::Client.new({:domain => "data.cityofnewyork.us", :app_token => "17ZY4jm7LcLozMBxNEdtLxR8B"})

  def report_by_zip_code(zip_code)
    response = client.get(table, {incident_zip: zip_code, "$limit" => 10000})
    hashify(response)
  end

  def report_by_descriptor(descriptor)
    response = JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?descriptor=#{descriptor}&$limit=25000").read, symbolize_names: true)
    hashify(response, :incident_zip)
  end

  def report_any(column, value, group_by)
    response = client.get(table, {column => value})
    hashify(response, group_by)
  end

  def hashify(input_hash, column = :descriptor)
    count_hash = {}
    input_hash.each do |entry|
      count_hash[entry[column]] == nil ? count_hash[entry[column]] = 1 : count_hash[entry[column]] += 1
    end
    count_hash.sort_by(&:last).each do |k, v|
      puts "#{k}: #{v}"
    end
  end

  def jeopardy
    @pid = fork{ exec 'afplay Jeopardy-theme-song.mp3'}
  end

  def kill_jeopardy
    Process.kill "TERM", @pid
  end
end
