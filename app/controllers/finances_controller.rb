class FinancesController < ApplicationController
  before_action :set_finance, only: %i[ show edit update destroy ]
  $urlpath = "http://jstranslogistik.com/"
  #$urlpath = "http://localhost/jstranswebapp/"

  def undo_payment
    @finance = Finance.find(params[:id])

    @finance.payment_date = nil
    @finance.payment_document = nil
    @finance.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")

    @finance.save

    redirect_to(finances_url)
  end

  def sync_all
    @finances = Finance.where("sync_at is NULL OR sync_at < edited_at")

    @linkurl = []

    @finances.each do |finance|
      @link = $urlpath.to_s+"sync/?"+
      "target=finance"+
      "&uid="+finance.uid.to_s+
      "&total_billing="+finance.total_billing.to_s

      if !finance.payment_date.nil?
        @link += "&payment_date="+finance.payment_date.to_s
      end 

      @total_assignment = Assignment.where("finance_reference = ? and active = 1", finance.id).count 
      @invoice_date = "-"

      if(@total_assignment!=0)
        @targeted_assignment = Assignment.where("finance_reference = ? and active = 1", finance.id).first 

        if !@targeted_assignment.container_id.nil? && @targeted_assignment.container_id != 0
          if !Container.find(@targeted_assignment.container_id).shipment_id.nil? && Container.find(@targeted_assignment.container_id).shipment_id != 0
            @targeted_shipment = Shipment.find(Container.find(@targeted_assignment.container_id).shipment_id)

            if(!@targeted_shipment.actualdeparture.nil?)
              @invoice_date = @targeted_shipment.actualdeparture
            end
          end
        end
      end

      @link += "&description="+@invoice_date.to_s+
      "&active="+finance.active.to_s+  
      "&code=server"+
      "&subcode="+finance.id.to_s 

      @linkurl.push(@link)
    
      #saving sync datetime
      finance.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
      if(finance.edited_at.nil?)
        finance.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
      end

      @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

      finance.description = @response['response']
      finance.save
    end

    redirect_to(finances_url)
  end

  def sync
    finance = Finance.find(params[:id])

    @linkurl = []

    @link = $urlpath.to_s+"sync/?"+
    "target=finance"+
    "&uid="+finance.uid.to_s+
    "&total_billing="+finance.total_billing.to_s

    if !finance.payment_date.nil?
      @link += "&payment_date="+finance.payment_date.to_s
    end 

    @link += "&description="+finance.uid.to_s+
    "&active="+finance.active.to_s+  
    "&code=server"+
    "&subcode="+finance.id.to_s

    @linkurl.push(@link)
  
    #saving sync datetime
    finance.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
    if(finance.edited_at.nil?)
      finance.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
    end

    @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

    finance.description = @response['response']
    finance.save

    redirect_to(finances_url)
  end

  def document_invoice
    @customer_lists = Assignment.select("customer_id").where("finance_reference = ? and active = 1", params[:id]).group("customer_id")
    @assignments = Assignment.where("finance_reference = ? and active = 1", params[:id])

    @targeted_assignment = Assignment.where("finance_reference = ? and active = 1", params[:id]).first 

    @invoice_date = "-"
    if !@targeted_assignment.container_id.nil? && @targeted_assignment.container_id != 0
      if !Container.find(@targeted_assignment.container_id).shipment_id.nil? && Container.find(@targeted_assignment.container_id).shipment_id != 0
        @targeted_shipment = Shipment.find(Container.find(@targeted_assignment.container_id).shipment_id)

        if(!@targeted_shipment.actualdeparture.nil?)
          @invoice_date = @targeted_shipment.actualdeparture
        end
      end
    end

    @finance = Finance.find(params[:id])

    #Calculate Total Billing
    total_billing = 0
    included_assignment = Assignment.where("finance_reference = ?", @finance.id)
    included_assignment.each do |assignment|
      addvalue = assignment.grand_total
      if assignment.grand_total.nil?
        addvalue = 0
      end
      total_billing = total_billing + addvalue
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
      addvalue = assignment.grand_total
      if assignment.grand_total.nil?
        addvalue = 0
      end
      total_billing = total_billing + addvalue
    end
    finance.total_billing = total_billing
    finance.save

    redirect_to(edit_finance_path(params[:finance_reference], :keyword => keyword))
  end

  def attach_assignment
    keyword = params[:keyword]

    assignment = Assignment.find(params[:assignment_id])
    assignment.finance_reference = params[:finance_reference]
    if assignment.user_id.nil?
      assignment.user_id = 0
    end
    assignment.save

    #Calculate Total Billing
    total_billing = 0
    finance = Finance.find(params[:finance_reference])
    included_assignment = Assignment.where("finance_reference = ? and active = 1", params[:finance_reference])
    included_assignment.each do |assignment|
      addvalue = assignment.grand_total
      if assignment.grand_total.nil?
        addvalue = 0
      end
      total_billing = total_billing + addvalue
    end
    finance.total_billing = total_billing
    finance.save

    redirect_to(edit_finance_path(params[:finance_reference], :keyword => keyword))
  end

  # GET /finances or /finances.json
  def index
    @selectedfinance = Finance.where("total_billing = '0' and created_at > ?", 60.days.ago)

    @selectedfinance.each do |finance|
  
      check_assignments = Assignment.where("finance_reference = ?",finance.id).count
      
      if check_assignments == 0
        finance.active = 0
        finance.save
      end 
      
      if check_assignments > 0 
#        assignments = Assignment.where("finance_reference = ?",finance.id)
#        assignments.each do |assignment|
#          assignment.finance_reference = nil
#          assignment.save
#        end

        total_billing = 0
        included_assignment = Assignment.where("finance_reference = ?", finance.id)
        included_assignment.each do |assignment|
          addvalue = assignment.grand_total
          if assignment.grand_total.nil?
            addvalue = 0
          end
          total_billing = total_billing + addvalue
        end
        finance.total_billing = total_billing
        finance.save
      end
    end

    @selectedfinance = Finance.where("total_billing > '0' and created_at > ? AND active = 0", 60.days.ago)
    
    @selectedfinance.each do |finance|
      check_assignments = Assignment.where("finance_reference = ?",finance.id).count

      if(check_assignments>0)
        finance.active = 1
        finance.save
      end
    end

    @unpaid_finances = Finance.where("active = 1 AND payment_date is NULL")
    @unpaid_finances.each do |unpaid_finance|
      #Calculate Total Billing
      total_billing = 0
      included_assignment = Assignment.where("finance_reference = ?", unpaid_finance.id)
      included_assignment.each do |assignment|
        addvalue = assignment.grand_total
        if assignment.grand_total.nil?
          addvalue = 0
        end
        total_billing = total_billing + addvalue
      end
      unpaid_finance.total_billing = total_billing
      unpaid_finance.save
    end

    if !params[:datefrom].nil?
      @finances = Finance.where("created_at >= ? AND created_at <= ? AND active = 1", params[:datefrom], params[:dateto]).order("created_at DESC")  
    else
      @finances = Finance.where("active = 1").order("created_at DESC")
    end

    @unsync_finance = Finance.where("sync_at is NULL OR sync_at < edited_at").count
    
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
    @finance.user_id = current_user.id

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

      @availableassignments = Assignment.where(customer_id: @customer_id).or(Assignment.where("uid LIKE ? AND grand_total > 0 AND active = 1", "%#{keyword}%")).order("pickuptime DESC").and(Assignment.where("finance_reference = 0 OR finance_reference is NULL"))
    else
      @availableassignments = []
    end

    @financed_assignments = Assignment.where("finance_reference = ?", params[:id])

    @finance = Finance.find(params[:id])
    @finance.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
    @finance.save
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
        end

        @finance.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
        @finance.save

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
      params.require(:finance).permit(:uid, :total_billing, :payment_date, :payment_document, :description, :active, :user_id)
    end
end
