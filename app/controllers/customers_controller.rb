class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]

  def sync_all_customer
    @customer = Customer.where("(sync_at is NULL OR sync_at < edited_at) AND active = 1")

    @customer.each do |customer|
      @link = "http://jstranslogistik.com/sync/?"+
      "target=customer"+
      "&id="+customer.id.to_s+
      "&name="+customer.name.to_s+
      "&active="+customer.active.to_s

      @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

      customer.description = @response['response']

      if(@response['response']=="ok")
        #saving sync datetime
        customer.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
        if(customer.edited_at.nil?)
          customer.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
        end
      end

      customer.save
    end

    redirect_to(customers_url)
  end

  def sync_customer
    @customer = Customer.find(params[:id])

    @link = "http://jstranslogistik.com/sync/?"+
    "target=customer"+
    "&id="+@customer.id.to_s+
    "&name="+@customer.name.to_s+
    "&active="+@customer.active.to_s

    @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

    @customer.description = @response['response']

    if(@response['response']=="ok")
      #saving sync datetime
      @customer.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
      if(@customer.edited_at.nil?)
        @customer.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
      end
    end

    @customer.save

    redirect_to(customers_url)
  end

  # GET /customers or /customers.json
  def index
    @customers = Customer.where("active = 1")

    @unsync_customers = Customer.where("(sync_at is NULL OR sync_at < edited_at) AND active = 1")
  end

  # GET /customers/1 or /customers/1.json
  def show
    @customer_location_pickup = CustomerLocation.where("customer_id = ? AND pickup_or_dooring = 'Pickup'", params[:id])
    @customer_location_dooring = CustomerLocation.where("customer_id = ? AND pickup_or_dooring = 'Dooring'", params[:id])
    @customer_products = CustomerProduct.where("customer_id = ?", params[:id])

    @assignments = Assignment.where("customer_id = ?",params[:id])
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customer_url(@customer), notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customer_url(@customer), notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])

    @customer.active = 0
    @customer.save

    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:name, :address, :contact, :active, :description, :npwp, :person_responsible, :person_responsible_uid, :npwp_file, :person_responsible_file)
    end
end
