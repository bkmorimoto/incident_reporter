class Report

  def report_by_zip_code(zip_code)
    JSON.parse(open("https://data.cityofnewyork.us/resource/erm2-nwe9.json?incident_zip=#{zip_code}").read, symbolize_names: true)
  end

end
