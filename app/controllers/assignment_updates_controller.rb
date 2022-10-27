class AssignmentUpdatesController < ApplicationController
  before_action :set_assignment_update, only: %i[ show edit update destroy ]

  # GET /assignment_updates or /assignment_updates.json
  def index
    @assignment_updates = AssignmentUpdate.all
  end

  # GET /assignment_updates/1 or /assignment_updates/1.json
  def show
  end

  # GET /assignment_updates/new
  def new
    @assignment_update = AssignmentUpdate.new
  end

  # GET /assignment_updates/1/edit
  def edit
  end

  # POST /assignment_updates or /assignment_updates.json
  def create
    @assignment_update = AssignmentUpdate.new(assignment_update_params)

    respond_to do |format|
      if @assignment_update.save
        format.html { redirect_to assignment_update_url(@assignment_update), notice: "Assignment update was successfully created." }
        format.json { render :show, status: :created, location: @assignment_update }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignment_updates/1 or /assignment_updates/1.json
  def update
    respond_to do |format|
      if @assignment_update.update(assignment_update_params)
        format.html { redirect_to assignment_update_url(@assignment_update), notice: "Assignment update was successfully updated." }
        format.json { render :show, status: :ok, location: @assignment_update }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_updates/1 or /assignment_updates/1.json
  def destroy
    @assignment_update.destroy

    respond_to do |format|
      format.html { redirect_to assignment_updates_url, notice: "Assignment update was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment_update
      @assignment_update = AssignmentUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_update_params
      params.require(:assignment_update).permit(:uid, :document_type, :document_path)
    end
end
