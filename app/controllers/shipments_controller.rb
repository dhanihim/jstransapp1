class ShipmentsController < ApplicationController
  before_action :set_shipment, only: %i[ show edit update destroy ]

  def depart
    @shipments = Shipment.find(params[:id])
    @shipments.actualdeparture = DateTime.current.to_date
    @shipments.save

    redirect_to(root_path)
  end

  def document_packing_list
    @shipment = Shipment.find(params[:id])

    if(!params[:container_id].nil?)
      @containers = Container.where("id = ?", params[:container_id])
    else
      @containers = Container.where("shipment_id = ?", @shipment.id)
    end
  end

  def document_customer_packing_list
    @shipment = Shipment.find(params[:id])

    if(!params[:container_id].nil?)
      @containers = Container.where("id = ?", params[:container_id])
    else
      @containers = Container.where("shipment_id = ?", @shipment.id)
    end
  end

  def document_record
    @shipment = Shipment.find(params[:id])
    @assignment = Assignment.find(params[:assignment_id])
    @customer = Customer.find(@assignment.customer_id)
  end

  def document_dooring_list
    @shipment = Shipment.find(params[:id])

    @containers = Container.where("shipment_id = ?", @shipment.id)
    @dooring_agent = Agent.find(params[:dooring])
  end

  # GET /shipments or /shipments.json
  def index

    keyword = ""

    if(!params[:keyword].nil?)
      keyword = params[:keyword].upcase
    
      @shipments = Shipment.where("uid LIKE ? OR UPPER(shipname) LIKE ?", "%#{keyword}%", "%#{keyword}%")
      @shipmentsongoing = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualdeparture IS NULL", "%#{keyword}%", "%#{keyword}%")
      @shipmentsonwater = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualdeparture >= now() AND actualarrival IS NULL", "%#{keyword}%", "%#{keyword}%")
      @shipmentsfinished = Shipment.where("(uid LIKE ? OR UPPER(shipname) LIKE ?) AND actualarrival >= now()", "%#{keyword}%", "%#{keyword}%")
    else
      @shipments = Shipment.where("created_at >= ?", 30.days.ago)
      @shipmentsongoing = Shipment.where("created_at >= ? AND actualdeparture IS NULL", 30.days.ago)
      @shipmentsonwater = Shipment.where("created_at >= ? AND actualdeparture >= now() AND actualarrival IS NULL", 30.days.ago)
      @shipmentsfinished = Shipment.where("created_at >= ? AND actualarrival >= now()", 30.days.ago)
    end

    if(!params[:datefrom].nil? && !params[:dateto].nil?)

      if(params[:datetype]=="Created At")
        @shipments = Shipment.where("created_at >= ? AND created_at <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("created_at >= ? AND created_at <= ? AND actualdeparture IS NULL", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("created_at >= ? AND created_at <= ? AND actualdeparture <= now()", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("created_at >= ? AND created_at <= ? AND actualarrival <= now()", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Estimated Departure")
        @shipments = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualdeparture IS NULL", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualdeparture <= now()", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("estimateddeparture >= ? AND estimateddeparture <= ? AND actualarrival <= now()", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Estimated Arrival")
        @shipments = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualdeparture IS NULL", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualdeparture <= now()", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("estimatedarrival >= ? AND estimatedarrival <= ? AND actualarrival <= now()", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Actual Departure")
        @shipments = Shipment.where("actualdeparture >= ? AND actualdeparture <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualdeparture IS NULL", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualdeparture <= now()", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("actualdeparture >= ? AND actualdeparture <= ? AND actualarrival <= now()", params[:datefrom], params[:dateto])
      elsif(params[:datetype]=="Actual Arrival")
        @shipments = Shipment.where("actualarrival >= ? AND actualarrival <= ?", params[:datefrom], params[:dateto])
        @shipmentsongoing = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualdeparture IS NULL", params[:datefrom], params[:dateto])
        @shipmentsonwater = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualdeparture <= now()", params[:datefrom], params[:dateto])
        @shipmentsfinished = Shipment.where("actualarrival >= ? AND actualarrival <= ? AND actualarrival <= now()", params[:datefrom], params[:dateto])
      end
    end
  end

  # GET /shipments/1 or /shipments/1.json
  def show
    @customer_array = []
    @dooring_array = []
    @container = Container.where("shipment_id = ?", params[:id])

    @container.each do |container|
      container_id = container.id

      @assignment = Assignment.where("container_id = ?", container_id)
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
  end

  # POST /shipments or /shipments.json
  def create
    @shipment = Shipment.new(shipment_params)

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

    @shipment.destroy

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
