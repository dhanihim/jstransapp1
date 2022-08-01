class AssignmentDetailsController < ApplicationController
  before_action :set_assignment_detail, only: %i[ show edit update destroy ]

  # GET /assignment_details or /assignment_details.json
  def index
    if params[:id].nil?
      @assignment_details = AssignmentDetail.all
    elsif 
      @assignment_details = AssignmentDetail.where("assignment_id = ?", params[:id]).order("id DESC")
      @assignment = Assignment.find(params[:id])

      if @assignment.loadtype == "Full Container Load"
        @loadtype = 1
      else
        @loadtype = 2
      end

      @assignment_detail = AssignmentDetail.new
    end
  end

  # GET /assignment_details/1 or /assignment_details/1.json
  def show
  end

  # GET /assignment_details/new
  def new
    @assignment_detail = AssignmentDetail.new
  end

  # GET /assignment_details/1/edit
  def edit
  end

  # POST /assignment_details or /assignment_details.json
  def create
    @assignment_detail = AssignmentDetail.new(assignment_detail_params)

    total = 0

    if @assignment_detail.assignment.loadtype != "Full Container Load"
      pickup_address = Assignment.find(@assignment_detail.assignment_id).pickup_location
      dooring_location = CustomerLocation.find(@assignment_detail.assignment.destination_location).location_id

      customer_product_pricelist = CustomerProductPricelist.where("customer_product_id = ? AND customer_location_id = ? AND location_id = ?", @assignment_detail.customer_product_id, pickup_address, dooring_location)

      customer_product_pricelist.each do |customer_product_pricelist|
        if(@assignment_detail.unit == "Meter Cubic")
          total = customer_product_pricelist.percubic
        elsif(@assignment_detail.unit == "UOM")
          total = customer_product_pricelist.peruom
        elsif(@assignment_detail.unit == "Ton")
          total = customer_product_pricelist.pertonnage
        end
      end
    end

    @assignment_detail.total = total*@assignment_detail.quantity

    assignment_total = AssignmentDetail.where("assignment_id = ?", @assignment_detail.assignment_id).sum("total")

    @assignment = Assignment.find(@assignment_detail.assignment_id)
    @assignment.total_price = assignment_total + @assignment_detail.total
    @assignment.save

    respond_to do |format|
      if @assignment_detail.save
        format.html { redirect_to assignment_details_path(:id => @assignment_detail.assignment_id, :cid => @assignment_detail.customer_product.customer_id), notice: "Assignment detail was successfully created." }
        format.json { render :show, status: :created, location: @assignment_detail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignment_details/1 or /assignment_details/1.json
  def update
     if params[:id].nil?
      @return  = assignment_details_path
    elsif 
      @return  = assignment_details_path(:id => params[:id])
    end 

    respond_to do |format|
      if @assignment_detail.update(assignment_detail_params)
        format.html { redirect_to @return, notice: "Assignment detail was successfully updated." }
        format.json { render :show, status: :ok, location: @assignment_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_details/1 or /assignment_details/1.json
  def destroy

    assignment_total = AssignmentDetail.where("assignment_id = ?", @assignment_detail.assignment_id).sum("total")

    @assignment = Assignment.find(@assignment_detail.assignment_id)
    @assignment.total_price = assignment_total - @assignment_detail.total
    @assignment.save

    @assignment_detail.destroy

    respond_to do |format|
      format.html { redirect_to assignment_details_path(:id => @assignment_detail.assignment_id, :cid => @assignment_detail.customer_product.customer_id), notice: "Assignment detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment_detail
      @assignment_detail = AssignmentDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_detail_params
      params.require(:assignment_detail).permit(:assignment_id, :customer_product_id, :quantity, :unit, :total)
    end
end
