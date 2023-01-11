class DashboardController < ApplicationController
  def index
    @shipments = Shipment.where("estimateddeparture < now() AND actualdeparture is NULL AND active = 1")
  
    @container_id = [1]
    @shipment_id = Array.new
      
    @departuredshipments = Shipment.where("estimateddeparture < ?", Date.today - 30.days)
    @departuredshipments.each do |shipmment|
      @shipment_id.push(shipmment.id)

      selected_container = Container.where("shipment_id = ?", shipmment.id)
      selected_container.each do |container|
        @container_id.push(container.id)
      end
    end

    @assignments = Assignment.where("payment_status IS NULL AND active = 1").and(Assignment.where(container_id: @container_id))

    if(Time.now.month!=1)
      @beginning = Time.now.year.to_s+"-"+(Time.now.month - 1).to_s+"-01"

      @ending = Time.now.year.to_s+"-"+(Time.now.month).to_s+"-1"
      @ending = @ending.to_date - 1.days
    else
      @beginning = (Time.now.year - 1).to_s+"-"+"12-01"
      @ending = (Time.now.year - 1).to_s+"-"+"12-31"
    end

    @customer_transaction_ppn = Assignment.select("customer_id, SUM(grand_total) as transaction_total").where("created_at >= ? AND created_at <= ? AND ppn != 0", @beginning, @ending).group("customer_id")
    @customer_transaction_noppn = Assignment.select("customer_id, SUM(grand_total) as transaction_total").where("created_at >= ? AND created_at <= ? AND ppn = 0", @beginning, @ending).group("customer_id")
  
    @adjustedassignments = Assignment.where("price_adjustment != 0 AND active = 1 AND created_at >= ?", Time.now.in_time_zone("Jakarta") - 30.days)
  end
end
