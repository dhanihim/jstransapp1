class CustomerProductPricelistsController < ApplicationController
  before_action :set_customer_product_pricelist, only: %i[ show edit update destroy ]

  # GET /customer_product_pricelists or /customer_product_pricelists.json
  def index
    @customer_product_pricelists = CustomerProductPricelist.all
  end

  # GET /customer_product_pricelists/1 or /customer_product_pricelists/1.json
  def show
  end

  # GET /customer_product_pricelists/new
  def new
    @customer_product_pricelist = CustomerProductPricelist.new
  end

  # GET /customer_product_pricelists/1/edit
  def edit
    @customer_product_pricelist = CustomerProductPricelist.find(params[:id])

    @customer_product = @customer_product_pricelist.customer_product_id
  end

  # POST /customer_product_pricelists or /customer_product_pricelists.json
  def create
    @customer_product_pricelist = CustomerProductPricelist.new(customer_product_pricelist_params)

    respond_to do |format|
      if @customer_product_pricelist.save
        format.html { redirect_to customer_product_pricelist_url(@customer_product_pricelist), notice: "Customer product pricelist was successfully created." }
        format.json { render :show, status: :created, location: @customer_product_pricelist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_product_pricelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_product_pricelists/1 or /customer_product_pricelists/1.json
  def update
    respond_to do |format|
      if @customer_product_pricelist.update(customer_product_pricelist_params)
        format.html { redirect_to customer_product_pricelist_url(@customer_product_pricelist), notice: "Customer product pricelist was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_product_pricelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_product_pricelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_product_pricelists/1 or /customer_product_pricelists/1.json
  def destroy
    @customer_product_pricelist.destroy

    respond_to do |format|
      format.html { redirect_to customer_product_pricelists_url, notice: "Customer product pricelist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_product_pricelist
      @customer_product_pricelist = CustomerProductPricelist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_product_pricelist_params
      params.require(:customer_product_pricelist).permit(:percubic, :peruom, :per20ft, :per40ft, :per20od, :per21ft, :per20fr, :per40fr, :ppncategory, :active, :description, :customer_product_id, :customer_location_id, :location_id)
    end
end
