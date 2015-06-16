# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'action_view'
require 'csv'

Broker.delete_all
Policy.destroy_all

# Preload Brokers
CSV.foreach('private/data/brokers.csv') do |r|
  include ActionView::Helpers::NumberHelper
  Broker.create!(code:r[0], name:r[1], street:r[2], city:r[3], state:r[4],
  zip:r[5], email:r[6], contact_name:r[7], phone:number_to_phone(r[8])
  )
end

# Preload Policy Container
#CSV.foreach('private/data/container.csv') do |r|
#  Policy.create!(number:r[0], code:r[1], name:r[2],
#  effective: Date.strptime(r[3], '%m/%d/%Y')
#  )
#end

# Load Policy Information
CSV.foreach('private/data/policy.csv') do |r|
  Policy.create!(number:r[0], code:r[1], effective: Date.strptime(r[2], '%m/%d/%y'),
  expiry:Date.strptime(r[3], '%m/%d/%Y'), broker_id: Broker.find_by_code(r[4]),
  name:r[5], org:r[6], dba:r[7], biztype:r[8], street:r[9], city:r[10], state:r[11],
  zip:r[12], total_premium:r[13]
  )
end
