# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'actionview'
require 'csv'

CSV.foreach('private/data/brokers.csv') do |r|
  Broker.create!(code:r[0], name:r[1], street:r[2], city:r[3], state:r[4],
  zip:r[5], email:r[6], contact_name:r[7], phone:number_to_phone(r[8])
  )
end
