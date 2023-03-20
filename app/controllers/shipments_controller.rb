class ShipmentsController < ApplicationController
  before_action :set_shipment, only: %i[ show edit update destroy ]

  def rename
    @shipment = Shipment.find(params[:id])

    @new_shipment = @shipment.dup

    @new_shipment.uid = params[:uid]
    @new_shipment.shipname = params[:shipname]
    @new_shipment.voyage = params[:voyage]

    @new_shipment.save

    @containers = Container.where("shipment_id = ?", params[:id])

    @containers.each do |container|
      container.shipment_id = @new_shipment.id 
      container.save
    end

    #deactive old shipment
    @shipment.active = 0
    @shipment.save

    #insert into shipment history
    @shipment_history = ShipmentHistory.new 
    @shipment_history.shipment_from_id = @shipment.id
    @shipment_history.shipment_to_id = @new_shipment.id
    @shipment_history.description = "Rename"
    @shipment_history.save

    redirect_to(shipments_url)
  end

  def merge
    if(!params[:target].nil?)
      @shipment = Shipment.find(params[:target])
    else
      @shipment_1 = Shipment.find(params[:shipment_from_id_1])
      @shipment_2 = Shipment.find(params[:shipment_from_id_2])

      #Old code for moving container from 2 ship
      #@container = Container.where("shipment_id = ? OR shipment_id = ?", @shipment_1.id, @shipment_2.id)
      
      #New code, move only shipment 1 to shipment 2
      @container = Container.where("shipment_id = ?", @shipment_1.id)
    end
  end

  def merge_action
    @shipment_1 = Shipment.find(params[:shipment_from_id_1])
    @shipment_2 = Shipment.find(params[:shipment_from_id_2])

    shipment = Shipment.new 

    shipment.uid = params[:uid]
    shipment.shipname = params[:shipname]
    shipment.voyage = params[:voyage]
    shipment.estimateddeparture = params[:estimateddeparture]
    shipment.estimatedarrival = params[:estimatedarrival]
    shipment.actualdeparture = params[:actualdeparture]
    shipment.actualarrival = params[:actualarrival]
    shipment.pol = params[:pol]
    shipment.pod = params[:pod]
    shipment.active = params[:active]
    shipment.description = params[:description]

    shipment.save

    shipment_history1 = ShipmentHistory.new 
    shipment_history1.shipment_from_id = @shipment_1.id
    shipment_history1.shipment_to_id = shipment.id
    shipment_history1.description = "Merge"
    shipment_history1.save

    shipment_history2 = ShipmentHistory.new 
    shipment_history2.shipment_from_id = @shipment_2.id
    shipment_history2.shipment_to_id = shipment.id
    shipment_history2.description = "Merge"
    shipment_history2.save

    #moving checked container
    counter = 1
    lastcounter = params[:lastcounter]

    for i in 1..params[:lastcounter].to_i
      value = params[:checkbox.to_s+i.to_s]
      if !value.nil?
        container = Container.find(value)
        container.shipment_id = shipment.id
        container.save

        assignment = Assignment.where("container_id = ?", container.id)
        assignment.each do |assignment|
          assignment.edited_at = DateTime.now
          assignment.save
        end
      end
    end

    @container_from_shipment_2 = Container.where("shipment_id = ?",@shipment_2)
    @container_from_shipment_2.each do |container|
      container.shipment_id = shipment.id
      container.save

      assignment = Assignment.where("container_id = ?", container.id)
      assignment.each do |assignment|
        assignment.edited_at = DateTime.now
        assignment.save
      end
    end

    redirect_to shipments_url, flash: {notice: "Shipment successfully merged"}

  end

  def document_invoice
    @shipment = Assignment.find(params[:shipment_id])
    @customer = Assignment.find(params[:customer])
  end

  def remove_container_shipment
    container_id = params[:container_id]

    @container = Container.find(container_id)

    shipment = Shipment.find(@container.shipment_id)
    @container.shipment_id = nil

    @container.save

    redirect_to(edit_shipment_url(shipment))
  end

  def update_container_shipment
    container_id = params[:container_id]
    shipment_id = params[:shipment_id]

    @container = Container.find(container_id)
    shipment = Shipment.find(shipment_id)

    @container.shipment_id = shipment_id

    @container.save

    redirect_to(edit_shipment_url(shipment))
  end

  def depart
    @shipments = Shipment.find(params[:id])
    @shipments.actualdeparture = DateTime.current.to_date
    @shipments.save

    redirect_to(root_path)
  end

  def document_packing_list
    @shipment = Shipment.find(params[:id])

    if(!params[:container_id].nil?)
      @containers = Container.where("id = ? AND active = 1", params[:container_id])
    else
      @containers = Container.where("shipment_id = ? AND active = 1", @shipment.id)
    end
  end

  def document_customer_packing_list
    @shipment = Shipment.find(params[:id])

    if(!params[:container_id].nil?)
      @containers = Container.where("id = ? AND active = 1", params[:container_id])
    else
      @containers = Container.where("shipment_id = ? AND active = 1", @shipment.id)
    end
  end

  def document_record
    @shipment = Shipment.find(params[:id])
    @assignment = Assignment.find(params[:assignment_id])
    @customer = Customer.find(@assignment.customer_id)
  end

  def document_dooring_list
    @shipment = Shipment.find(params[:id])

    @containers = Container.where("shipment_id = ? AND active = 1", @shipment.id)
    @dooring_agent = Agent.find(params[:dooring])
  end

  # GET /shipments or /shipments.json
  def index
    keyword = ""

    if(!params[:keyword].nil?)
      keyword = params[:keyword].upcase
    
      @shipments = Shipment.where("uid LIKE ? OR UPPER(shipname) LIKE ? AND active = 1", "%#{keyword}%", "%#{keyword}%")
      @shipmentsongoing = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualdeparture IS NULL AND active = 1", "%#{keyword}%", "%#{keyword}%")
      @shipmentsonwater = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualdeparture >= now() AND actualarrival IS NULL AND active = 1", "%#{keyword}%", "%#{keyword}%")
      @shipmentsfinished = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualarrival >= now() AND active = 1", "%#{keyword}%", "%#{keyword}%")
    else
      @shipments = Shipment.where("created_at >= ? AND active = 1", 30.days.ago).order("created_at DESC")
      @shipmentsongoing = Shipment.where("created_at >= ? AND actualdeparture IS NULL AND active = 1", 30.days.ago)
      @shipmentsonwater = Shipment.where("created_at >= ? AND actualdeparture >= now() AND actualarrival IS NULL AND active = 1", 30.days.ago)
      @shipmentsfinished = Shipment.where("created_at >= ? AND actualarrival >= now() AND active = 1", 30.days.ago)
    end

    if(!params[:datefrom].nil? && !params[:dateto].nil?)

      if(params[:datetype]=="Created At")
        @shipments = Shipment.where("created_at >= ? AND created_at <= ? AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("created_at >= ? AND created_at <= ? AND actualdeparture IS NULL AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("created_at >= ? AND created_at <= ? AND actualdeparture <= now() AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("created_at >= ? AND created_at <= ? AND actualarrival <= now() AND active = 1", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Estimated Departure")
        @shipments = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualdeparture IS NULL AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualdeparture <= now() AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualarrival <= now() AND active = 1", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Estimated Arrival")
        @shipments = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualdeparture IS NULL AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualdeparture <= now() AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualarrival <= now() AND active = 1", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Actual Departure")
        @shipments = Shipment.where("actualdeparture >= ? AND actualdeparture <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualdeparture IS NULL AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualdeparture <= now() AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualarrival <= now() AND active = 1", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Actual Arrival")
        @shipments = Shipment.where("actualarrival >= ? AND actualarrival <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualdeparture IS NULL AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualdeparture <= now() AND active = 1", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualarrival <= now() AND active = 1", params[:datefrom], params[:dateto])
      end
    end
  end

  # GET /shipments/1 or /shipments/1.json
  def show
    @customer_array = []
    @dooring_array = []
    @container = Container.where("shipment_id = ? AND active = 1", params[:id])

    @container.each do |container|
      container_id = container.id

      @assignment = Assignment.where("container_id = ? AND active = 1", container_id)
      @assignment.each do |assignment|
        customer_id = assignment.customer_id
        dooring_id = assignment.dooring_agent_id
        
        if(!@customer_array.include? customer_id)
          @customer_array.push(customer_id)
        end

        if(!@dooring_array.include? dooring_id)
          @dooring_array.push(dooring_id)
        end
      end
    end
  end

  # GET /shipments/new
  def new
    @shipment = Shipment.new
  end

  # GET /shipments/1/edit
  def edit
    @containeravailable = Container.where("(shipment_id = 0 OR shipment_id is NULL) AND active = 1")
    @containerassigned = Container.where("shipment_id = ? AND active = 1",params[:id])
  end

  # POST /shipments or /shipments.json
  def create
    @shipment = Shipment.new(shipment_params)
    @shipment.uid = "JST-"+DateTime.now.strftime("%Y%m%d%H%M")

    respond_to do |format|
      if @shipment.save
        format.html { redirect_to shipments_path, notice: "Shipment was successfully created." }
        format.json { render :show, status: :created, location: @shipment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shipments/1 or /shipments/1.json
  def update
    respond_to do |format|
      if @shipment.update(shipment_params)
        format.html { redirect_to shipments_path, notice: "Shipment was successfully updated." }
        format.json { render :show, status: :ok, location: @shipment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipments/1 or /shipments/1.json
  def destroy
    @shipment_id = @shipment.id

    @container = Container.where("shipment_id = ?", @shipment_id)
    @container.each do |container|
      container.shipment_id = nil
      container.save
    end

    @shipment.active = 0
    @shipment.save

    respond_to do |format|
      format.html { redirect_to shipments_path, notice: "Shipment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shipment_params
      params.require(:shipment).permit(:uid, :shipname, :voyage, :estimateddeparture, :estimatedarrival, :actualdeparture, :actualarrival, :active, :description, :pol, :pod)
    end
end
