class FinanceUpdatesController < ApplicationController
  before_action :set_finance_update, only: %i[ show edit update destroy ]

  # GET /finance_updates or /finance_updates.json
  def index
    @finance_updates = FinanceUpdate.all
  end

  # GET /finance_updates/1 or /finance_updates/1.json
  def show
  end

  # GET /finance_updates/new
  def new
    @finance_update = FinanceUpdate.new
  end

  # GET /finance_updates/1/edit
  def edit
  end

  # POST /finance_updates or /finance_updates.json
  def create
    @finance_update = FinanceUpdate.new(finance_update_params)

    respond_to do |format|
      if @finance_update.save
        format.html { redirect_to finance_update_url(@finance_update), notice: "Finance update was successfully created." }
        format.json { render :show, status: :created, location: @finance_update }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @finance_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finance_updates/1 or /finance_updates/1.json
  def update
    respond_to do |format|
      if @finance_update.update(finance_update_params)
        format.html { redirect_to finance_update_url(@finance_update), notice: "Finance update was successfully updated." }
        format.json { render :show, status: :ok, location: @finance_update }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @finance_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finance_updates/1 or /finance_updates/1.json
  def destroy
    @finance_update.destroy

    respond_to do |format|
      format.html { redirect_to finance_updates_url, notice: "Finance update was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance_update
      @finance_update = FinanceUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def finance_update_params
      params.require(:finance_update).permit(:uid, :document_path, :description)
    end
end
