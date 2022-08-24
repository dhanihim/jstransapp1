class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[ show edit update destroy ]

  def update_assignment_container
    @assignment = Assignment.find(params[:id])

    @assignment.container_id = params[:container_id]

    @assignment.save

    redirect_to(container_url(params[:container_id]))
  end

  def remove_assignment_container
    @assignment = Assignment.find(params[:id])

    @assignment.container_id = nil

    @assignment.save

    redirect_to(container_url(params[:container_id]))
  end

  # GET /assignments or /assignments.json
  def index
    @assignmentsfcl = Assignment.where("loadtype = 'Full Container Load'").order("uid DESC")
    @assignmentslcl = Assignment.where("loadtype = 'Less Container Load'").order("uid DESC")
  end

  # GET /assignments/1 or /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments or /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to edit_assignment_path(@assignment, :customer_id => @assignment.customer_id), notice: "Assignment was successfully created." }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)

        @assignment.total_price = 0
        loadtype = 2
        
        if(@assignment.loadtype == "Full Container Load")
          
          #get address and location
          pickup_location = CustomerLocation.find(@assignment.pickup_location)
          location = Location.find(CustomerLocation.find(@assignment.destination_location).location_id)
          
          price = CustomerLocationPricelist.where("customer_location_id = ? and location_id = ?", pickup_location, location)
          container = @assignment.containertype
          priceused = 0

          price.each do |price|
            if(container == "20FT" && price.per20ft!=0)
              priceused = price.per20ft
            elsif(container == "20FR" && price.per20fr!=0)
              priceused = price.per20fr
            elsif(container == "20OD" && price.per20od!=0)
              priceused = price.per20od
            elsif(container == "21FT" && price.per21ft!=0)
              priceused = price.per21ft
            elsif(container == "40FT" && price.per40ft!=0)
              priceused = price.per40ft
            elsif(container == "40FR" && price.per40fr!=0)
              priceused = price.per40fr
            end

            @assignment.total_price = priceused
          end
          loadtype = 1
          customer_id = @assignment.customer_id
        end

        if(priceused == 0)
          @assignment.destroy

          format.html { redirect_to assignments_url(:loadtype => loadtype, :customer_id => customer_id), alert: "No contract available" }
          format.json { render json: @assignment.errors, status: :unprocessable_entity }
        end

        @assignment.save

        format.html { redirect_to assignments_url(:loadtype => loadtype, :priceused => priceused), notice: "Assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1 or /assignments/1.json
  def destroy
    loadtype = 2

    if @assignment.loadtype == "Full Container Load"
      loadtype = 1
    end

    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to assignments_url(:loadtype => loadtype), notice: "Assignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_params
      params.require(:assignment).permit(:container_id, :agent_id, :customer_id, :pickup_location, :destination_location, :uid, :pickuptime, :document_status, :payment_status, :loadtype, :containertype, :active)
    end
end
