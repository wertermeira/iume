require 'net/http'
require 'json'

namespace :populate do
  desc 'Populate regions, states and cities'
  task cities: :environment do
    http = Net::HTTP.new('raw.githubusercontent.com', 443)
    http.use_ssl = true
    states = JSON.parse http.get('/celsodantas/br_populate/master/states.json').body

    states.each do |state|
      region_obj = Region.find_or_create_by(name: state['region'])
      state_obj = State.new(acronym: state['acronym'], name: state['name'], region: region_obj)
      state_obj.save
      state['cities'].each do |city|
        c = City.new
        c.name = city['name']
        c.state = state_obj
        c.capital = (city['city'] == state['capital'])
        c.save

        p "Adicionando a cidade #{c.name} ao estado #{c.state.name}"
      end
    end
  end

  desc 'Populate colors'
  task colors: :environment do
    file = Rails.root.join('vendor', 'files', 'colors.txt')
    File.open(file).each do |color|
      ThemeColor.find_or_create_by(color: color.strip)
    end
  end
end
