class ContainersController < ApplicationController
  before_action :set_container, only: %i[ show edit update destroy ]

  def update_container_shipment
    shipment_id = params[:shipment_id]
    container_id = params[:id]

    @container = Container.find(container_id)

    @container.shipment_id = shipment_id

    @container.save

    redirect_to(container_url(@container))
  end

  # GET /containers or /containers.json
  def index
    if !params[:keyword].nil?
      @containers = Container.where("LOWER(number) LIKE LOWER(?) or LOWER(sealnumber) LIKE LOWER(?)", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    elsif !params[:datefrom].nil?
      @containers = Container.where("created_at >= ? and created_at <= ? and active = 1", params[:datefrom], params[:dateto])
    else
      @containers = Container.where("created_at >= ? and active = 1",30.days.ago)
    end

    @containers.each do |container|
      if(!container.shipment_id.nil? && container.shipment_id != 0)
        if(Shipment.find(container.shipment_id).active == 0)
          container.shipment_id = 0
          container.save
        end
      end
    end
  end

  # GET /containers/1 or /containers/1.json
  def show
    @assignmentsavailable = Assignment.where("container_id IS NULL AND containertype = ? AND active = 1", Container.find(params[:id]).size)
    @assignmentsassigned = Assignment.where("container_id = ? AND active = 1", params[:id])

    @containers = Container.find(params[:id])
  end

  # GET /containers/new
  def new
    @container = Container.new
  end

  # GET /containers/1/edit
  def edit
  end

  # POST /containers or /containers.json
  def create
    @container = Container.new(container_params)

    respond_to do |format|
      if @container.save
        format.html { redirect_to containers_path, notice: "Container was successfully created." }
        format.json { render :show, status: :created, location: @container }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /containers/1 or /containers/1.json
  def update
    respond_to do |format|
      if @container.update(container_params)
        format.html { redirect_to containers_path, notice: "Container was successfully updated." }
        format.json { render :show, status: :ok, location: @container }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /containers/1 or /containers/1.json
  def destroy
    @container_id = @container.id

    @assignment = Assignment.where("container_id = ?", @container_id)
    @assignment.each do |assignment|
      assignment.container_id = nil
      assignment.save
    end

    @container.destroy

    respond_to do |format|
      format.html { redirect_to containers_url, notice: "Container was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_container
      @container = Container.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def container_params
      params.require(:container).permit(:pol, :pod, :number, :sealnumber, :size, :active, :description, :shipment_id, :user_id)
    end
end
