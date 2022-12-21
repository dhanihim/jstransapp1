class FinancesController < ApplicationController
  before_action :set_finance, only: %i[ show edit update destroy ]

  def document_invoice
    @customer_lists = Assignment.select("customer_id").where("finance_reference = ? and active = 1", params[:id]).group("customer_id")
    @assignments = Assignment.where("finance_reference = ? and active = 1", params[:id])

    @finance = Finance.find(params[:id])

    #Calculate Total Billing
    total_billing = 0
    included_assignment = Assignment.where("finance_reference = ?", @finance.id)
    included_assignment.each do |assignment|
      total_billing = total_billing + assignment.grand_total
    end
    @finance.total_billing = total_billing
    @finance.save
  end

  def remove_assignment
    keyword = params[:keyword]

    assignment = Assignment.find(params[:assignment_id])
    assignment.finance_reference = 0
    assignment.save

    #Calculate Total Billing
    total_billing = 0
    finance = Finance.find(params[:finance_reference])
    included_assignment = Assignment.where("finance_reference = ?", params[:finance_reference])
    included_assignment.each do |assignment|
      total_billing = total_billing + assignment.grand_total
    end
    finance.total_billing = total_billing
    finance.save

    redirect_to(edit_finance_path(params[:finance_reference], :keyword => keyword))
  end

  def attach_assignment
    keyword = params[:keyword]

    assignment = Assignment.find(params[:assignment_id])
    assignment.finance_reference = params[:finance_reference]
    assignment.save

    #Calculate Total Billing
    total_billing = 0
    finance = Finance.find(params[:finance_reference])
    included_assignment = Assignment.where("finance_reference = ?", params[:finance_reference])
    included_assignment.each do |assignment|
      total_billing = total_billing + assignment.grand_total
    end
    finance.total_billing = total_billing
    finance.save

    redirect_to(edit_finance_path(params[:finance_reference], :keyword => keyword))
  end

  # GET /finances or /finances.json
  def index
    @selectedfinance = Finance.where("total_billing = '0'")

    @selectedfinance.each do |finance|
      finance.active = 0
      finance.save

      assignments = Assignment.where("finance_reference = ?",finance.id)
      assignments.each do |assignment|
        assignment.finance_reference = nil
        assignment.save
      end
    end

    @finances = Finance.where("active = 1").order("created_at DESC")

    @unpaid_finances = Finance.where("active = 1 AND payment_date is NULL")
    @unpaid_finances.each do |unpaid_finance|
      #Calculate Total Billing
      total_billing = 0
      included_assignment = Assignment.where("finance_reference = ?", unpaid_finance.id)
      included_assignment.each do |assignment|
        total_billing = total_billing + assignment.grand_total
      end
      unpaid_finance.total_billing = total_billing
      unpaid_finance.save
    end
  end

  # GET /finances/1 or /finances/1.json
  def show
  end

  # GET /finances/new
  def new
    @finance = Finance.new

    @finance.uid = 'INV/'+Time.now.to_i.to_s+'/'+Time.now.year.to_s
    @finance.active = 1
    @finance.total_billing = 0

    @finance.save

    redirect_to(edit_finance_url(@finance))
  end

  # GET /finances/1/edit
  def edit
    if !params[:keyword].nil?
      keyword = params[:keyword].upcase

      @customer_id = []

      customer = Customer.where("UPPER(name) LIKE ?", "%#{keyword}%")

      customer.each do |customer|
        @customer_id.push(customer.id)
      end

      @availableassignments = Assignment.where(customer_id: @customer_id).or(Assignment.where("uid LIKE ? ", "%#{keyword}%")).order("pickuptime DESC").and(Assignment.where("finance_reference = 0 OR finance_reference is NULL"))
    else
      @availableassignments = []
    end

    @financed_assignments = Assignment.where("finance_reference = ?", params[:id])

    @finance = Finance.find(params[:id])
  end

  # POST /finances or /finances.json
  def create
    @finance = Finance.new(finance_params)

    respond_to do |format|
      if @finance.save
        format.html { redirect_to finance_url(@finance), notice: "Finance was successfully created." }
        format.json { render :show, status: :created, location: @finance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @finance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finances/1 or /finances/1.json
  def update
    respond_to do |format|
      if @finance.update(finance_params)

        if !@finance.payment_document.nil?
          @finance.payment_date = Time.now.strftime("%d/%m/%Y")
          @finance.save
        end

        format.html { redirect_to finances_url, notice: "Finance was successfully updated." }
        format.json { render :show, status: :ok, location: @finance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @finance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finances/1 or /finances/1.json
  def destroy
    #@finance.destroy

    assignment = Assignment.where("finance_reference = ?",@finance.id)
    assignment.each do |assignment|
      assignment.finance_reference = nil
      assignment.save
    end

    @finance.active = 0
    @finance.save

    respond_to do |format|
      format.html { redirect_to finances_url, notice: "Finance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance
      @finance = Finance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def finance_params
      params.require(:finance).permit(:uid, :total_billing, :payment_date, :payment_document, :description, :active)
    end
end
