require 'action_view'
require 'csv'

namespace :preload do
  desc 'Preload broker data'
  task :brokers => :environment do
    include ActionView::Helpers::NumberHelper

    CSV.foreach('public/data/brokers.csv') do |r|
      Broker.create!(code:r[0], name:r[1], street:r[2], city:r[3], state:r[4],
      zip:r[5], email:r[6], contact_name:r[7], phone:number_to_phone(r[8])
      )
    end
  end

end
