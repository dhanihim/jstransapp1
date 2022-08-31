class DashboardController < ApplicationController
  def index
    @shipments = Shipment.where("estimateddeparture < now() AND actualdeparture is NULL")
  
    @assignments = Assignment.where("payment_status IS NULL")
  end
end
