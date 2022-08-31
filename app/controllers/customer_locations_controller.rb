class CustomerLocationsController < ApplicationController
  before_action :set_customer_location, only: %i[ show edit update destroy ]

  # GET /customer_locations or /customer_locations.json
  def index
    @customer_locations = CustomerLocation.all
  end

  # GET /customer_locations/1 or /customer_locations/1.json
  def show
    @customer_id = @customer_location.customer_id

    @customer_locations = CustomerLocation.find(params[:id])
    @dooring_locations = Location.where("active = 1")

    @dooring_locations.each do |dooring_location|
      @dooringid = dooring_location.id
      @available = CustomerLocationPricelist.where("customer_location_id = ? AND location_id = ?", @customer_locations.id, @dooringid).count

      if(@available==0)
        @customer_location_pricelist = CustomerLocationPricelist.new
        @customer_location_pricelist.per40fr = 0
        @customer_location_pricelist.per20fr = 0
        @customer_location_pricelist.per21ft = 0
        @customer_location_pricelist.per20od = 0
        @customer_location_pricelist.per40ft = 0
        @customer_location_pricelist.per20ft = 0
        @customer_location_pricelist.active = 1
        @customer_location_pricelist.customer_location_id = @customer_locations.id;
        @customer_location_pricelist.location_id = @dooringid;

        @customer_location_pricelist.save
      end
    end

    @customer_location_pricelists = CustomerLocationPricelist.where("customer_location_id = ?", @customer_locations.id).order("location_id ASC")
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
      params.require(:customer_location).permit(:address, :active, :description, :customer_id, :location_id, :pickup_or_dooring)
    end
end
