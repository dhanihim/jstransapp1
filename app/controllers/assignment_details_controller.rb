class AssignmentDetailsController < ApplicationController
  before_action :set_assignment_detail, only: %i[ show edit update destroy ]

  # GET /assignment_details or /assignment_details.json
  def index
    if params[:id].nil?
      @assignment_details = AssignmentDetail.all
    elsif 
      @assignment_details = AssignmentDetail.where("assignment_id = ?", params[:id]).order("id DESC")
      @assignment = Assignment.find(params[:id])
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
      params.require(:assignment_detail).permit(:assignment_id, :customer_product_id, :quantity, :total)
    end
end
