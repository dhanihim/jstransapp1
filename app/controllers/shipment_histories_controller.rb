class ShipmentHistoriesController < ApplicationController
  before_action :set_shipment_history, only: %i[ show edit update destroy ]

  # GET /shipment_histories or /shipment_histories.json
  def index
    @shipment_histories = ShipmentHistory.all
  end

  # GET /shipment_histories/1 or /shipment_histories/1.json
  def show
  end

  # GET /shipment_histories/new
  def new
    @shipment_history = ShipmentHistory.new
  end

  # GET /shipment_histories/1/edit
  def edit
  end

  # POST /shipment_histories or /shipment_histories.json
  def create
    @shipment_history = ShipmentHistory.new(shipment_history_params)

    respond_to do |format|
      if @shipment_history.save
        format.html { redirect_to shipment_history_url(@shipment_history), notice: "Shipment history was successfully created." }
        format.json { render :show, status: :created, location: @shipment_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shipment_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shipment_histories/1 or /shipment_histories/1.json
  def update
    respond_to do |format|
      if @shipment_history.update(shipment_history_params)
        format.html { redirect_to shipment_history_url(@shipment_history), notice: "Shipment history was successfully updated." }
        format.json { render :show, status: :ok, location: @shipment_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shipment_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipment_histories/1 or /shipment_histories/1.json
  def destroy
    @shipment_history.destroy

    respond_to do |format|
      format.html { redirect_to shipment_histories_url, notice: "Shipment history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment_history
      @shipment_history = ShipmentHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shipment_history_params
      params.require(:shipment_history).permit(:shipment_from_id, :shipment_to_id, :description)
    end
end
