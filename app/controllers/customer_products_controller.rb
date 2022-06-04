class CustomerProductsController < ApplicationController
  before_action :set_customer_product, only: %i[ show edit update destroy ]

  # GET /customer_products or /customer_products.json
  def index
    @customer_products = CustomerProduct.all
  end

  # GET /customer_products/1 or /customer_products/1.json
  def show
    @customer_products = CustomerProduct.find(params[:id])
    @customer_id = @customer_products.customer_id

    @customer_locations = CustomerLocation.where("customer_id = ?", @customer_id)
    @dooring_locations = Location.where("active = 1")

    @customer_locations.each do |customer_location|
      @locationid = customer_location.id
      @productid = params[:id]
        
      @dooring_locations.each do |dooring_location|
        @dooringid = dooring_location.id
        @available = CustomerProductPricelist.where("customer_location_id = ? AND customer_product_id = ? AND location_id = ?", @locationid, @productid, @dooringid).count

        if(@available==0)
          @customer_product_pricelist = CustomerProductPricelist.new

          @customer_product_pricelist.percubic = 0;
          @customer_product_pricelist.peruom = 0;
          @customer_product_pricelist.per20ft = 0;
          @customer_product_pricelist.per40ft = 0;
          @customer_product_pricelist.per20od = 0;
          @customer_product_pricelist.per21ft = 0;
          @customer_product_pricelist.per20fr = 0;
          @customer_product_pricelist.per40fr = 0;
          @customer_product_pricelist.active = 1;
          @customer_product_pricelist.customer_product_id = @productid;
          @customer_product_pricelist.customer_location_id = @locationid;
          @customer_product_pricelist.location_id = @dooringid;

          @customer_product_pricelist.save
        end
      end
    end

    @customer_product_pricelist = CustomerProductPricelist.where("customer_product_id = ?", @productid)
  end

  # GET /customer_products/new
  def new
    @customer_product = CustomerProduct.new
    
    @customer_name = Customer.find(params[:customerid]).name
  end

  # GET /customer_products/1/edit
  def edit
    session[:return_to] = request.referer

    @customer_name = Customer.find(params[:customerid]).name
  end

  # POST /customer_products or /customer_products.json
  def create
    @customer_product = CustomerProduct.new(customer_product_params)

    respond_to do |format|
      if @customer_product.save
        format.html { redirect_to customer_path(@customer_product.customer_id), notice: "Customer product was successfully created." }
        format.json { render :show, status: :created, location: @customer_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_products/1 or /customer_products/1.json
  def update
    respond_to do |format|
      if @customer_product.update(customer_product_params)
        format.html { redirect_to session.delete(:return_to), notice: "Customer product was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_products/1 or /customer_products/1.json
  def destroy
    @customer_product.destroy

    respond_to do |format|
      format.html { redirect_to customer_path(@customer_product.customer_id), notice: "Customer product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_product
      @customer_product = CustomerProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_product_params
      params.require(:customer_product).permit(:name, :uom, :active, :description, :customer_id)
    end
end
