class CustomerLocationsController < ApplicationController
  before_action :set_customer_location, only: %i[ show edit update destroy ]

  # GET /customer_locations or /customer_locations.json
  def index
    @customer_locations = CustomerLocation.all
  end

  # GET /customer_locations/1 or /customer_locations/1.json
  def show
  end

  # GET /customer_locations/new
  def new
    @customer_location = CustomerLocation.new

    @customer_name = Customer.find(params[:customerid]).name
  end

  # GET /customer_locations/1/edit
  def edit
    session[:return_to] = request.referer

    @customer_name = Customer.find(params[:customerid]).name
  end

  # POST /customer_locations or /customer_locations.json
  def create
    @customer_location = CustomerLocation.new(customer_location_params)

    respond_to do |format|
      if @customer_location.save
        format.html { redirect_to customer_path(@customer_location.customer_id), notice: "Customer location was successfully created." }
        format.json { render :show, status: :created, location: @customer_location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_locations/1 or /customer_locations/1.json
  def update
    respond_to do |format|
      if @customer_location.update(customer_location_params)
        format.html { redirect_to session.delete(:return_to), notice: "Customer location was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_locations/1 or /customer_locations/1.json
  def destroy
    @customer_location.destroy

    respond_to do |format|
      format.html { redirect_to customer_path(@customer_location.customer_id), notice: "Customer location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_location
      @customer_location = CustomerLocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_location_params
      params.require(:customer_location).permit(:address, :active, :description, :customer_id, :location_id)
    end
end
