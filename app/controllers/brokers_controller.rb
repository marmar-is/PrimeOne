class BrokersController < ApplicationController

  # GET /policies
  # GET /policies.json
  def index
    @brokers = Broker.all
  end
end
