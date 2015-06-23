# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'action_view'
require 'csv'

Policy.destroy_all
Broker.destroy_all

# Preload Brokers
CSV.foreach('private/data/brokers.csv') do |r|
  include ActionView::Helpers::NumberHelper
  Broker.create!(code:r[0], name:r[1], street:r[2], city:r[3], state:r[4],
  zip:r[5], email:r[6], contact_name:r[7], phone:number_to_phone(r[8])
  )
end

# Load Policy Information
CSV.foreach('private/data/policy.csv', { headers: true }) do |r|
  Policy.create!(number:r[0], code:r[1], effective: Date.strptime(r[2], '%m/%d/%y'),
  expiry:Date.strptime(r[3], '%m/%d/%y'), name:r[5], org:r[6], dba:r[7],
  biztype:r[8], street:r[9], city:r[10], state:r[11], zip:r[12],
  total_premium:r[13],
  broker_id: Broker.find_by_code(r[4]).try(:id)
  )
end

# Load Auto Information into Policy
CSV.foreach('private/data/auto.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).create_auto(total: r[1])
end

# Load Crime Information into Policy
CSV.foreach('private/data/crime.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).create_crime(total:r[1], ded:r[2],
  limit_theft:r[3], limit_forgery:r[4], limit_money:r[5],
  limit_outside_robbery:r[6], limit_safe_burglary:r[7], limit_premises_burglary:r[8]
  )
end

# Load GL Information into Policy
CSV.foreach('private/data/gl.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).create_gl(total:r[1],
  limit_genagg:r[2], limit_products:r[3], limit_occurence:r[4],
  limit_injury:r[5], limit_fire:r[6], limit_medical:r[7], water_gas_tank:r[8]
  )
end

# Load Location Information into Policy
CSV.foreach('private/data/location.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).locations.create(number:r[1],
  street:r[2], city:r[3], state:r[4], zip:r[5], total:r[6],
  loss_coverage:r[7], enhancement:r[8], mechanical:r[9], theft:r[10],
  spoilage:r[11], coins:r[12], valuation:r[13], ded:r[14], limt_bldg:r[15],
  limit_bpp:r[16], limit_earnings:r[17], limit_sign:r[18], limit_pumps:r[19],
  limit_canopies:r[20], indemnity:r[21]
  )
end

# Load Location's Building Information into Policy
CSV.foreach('private/data/building.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).locations.first.buildings.create(number:r[1],
  class_type:r[2], code:r[3], basis:r[4], basis_type:r[5]
  )
end

# Load Property Information into Policy
CSV.foreach('private/data/property.csv', { headers: true }) do |r|
  Policy.find_by_number(r[0]).create_property(total:r[1])
end
