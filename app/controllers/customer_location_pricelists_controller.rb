class CustomerLocationPricelistsController < ApplicationController
  before_action :set_customer_location_pricelist, only: %i[ show edit update destroy ]

  # GET /customer_location_pricelists or /customer_location_pricelists.json
  def index
    @customer_location_pricelists = CustomerLocationPricelist.all
  end

  # GET /customer_location_pricelists/1 or /customer_location_pricelists/1.json
  def show
  end

  # GET /customer_location_pricelists/new
  def new
    @customer_location_pricelist = CustomerLocationPricelist.new
  end

  # GET /customer_location_pricelists/1/edit
  def edit
  end

  # POST /customer_location_pricelists or /customer_location_pricelists.json
  def create
    @customer_location_pricelist = CustomerLocationPricelist.new(customer_location_pricelist_params)

    respond_to do |format|
      if @customer_location_pricelist.save

        @customer_location_id = @customer_location_pricelist.customer_location_id

        format.html { redirect_to customer_location_url(@customer_location_id), notice: "Customer location pricelist was successfully created." }
        format.json { render :show, status: :created, location: @customer_location_pricelist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_location_pricelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_location_pricelists/1 or /customer_location_pricelists/1.json
  def update
    respond_to do |format|
      if @customer_location_pricelist.update(customer_location_pricelist_params)

        @customer_location_id = @customer_location_pricelist.customer_location_id
        
        format.html { redirect_to customer_location_url(@customer_location_id), notice: "Customer location pricelist was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_location_pricelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_location_pricelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_location_pricelists/1 or /customer_location_pricelists/1.json
  def destroy
    @customer_location_pricelist.per20ft = 0
    @customer_location_pricelist.per20fr = 0
    @customer_location_pricelist.per20od = 0
    @customer_location_pricelist.per21ft = 0
    @customer_location_pricelist.per40ft = 0
    @customer_location_pricelist.per40fr = 0
    @customer_location_pricelist.ppncategory = nil
    @customer_location_pricelist.expireddate = nil

    @customer_location_pricelist.save

    respond_to do |format|
      format.html { redirect_to customer_location_url(@customer_location_pricelist.customer_location_id), notice: "Customer location pricelist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_location_pricelist
      @customer_location_pricelist = CustomerLocationPricelist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_location_pricelist_params
      params.require(:customer_location_pricelist).permit(:ppncategory, :active, :description, :customer_location_id, :location_id, :per20ft, :per40ft, :per20od, :per21ft, :per20fr, :per40fr, :expireddate)
    end
end
