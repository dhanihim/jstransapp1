class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[ show edit update destroy ]
  $urlpath = "http://jstranslogistik.com/"
  #$urlpath = "http://localhost/jstranswebapp/"

  def price_adjustment
    assignment = Assignment.find(params[:id])

    if assignment.ppn != 0
      #ppn 1.1%
      assignment.ppn = (params[:total_price].to_i - params[:price_adjustment].to_i)*0.011  
    end

    assignment.price_adjustment = params[:price_adjustment].to_i
    assignment.grand_total = params[:total_price].to_i - params[:price_adjustment].to_i + assignment.ppn.to_i
    assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
    assignment.save

    redirect_to(assignments_url(:loadtype => params[:loadtype]))
  end

  def duplicate
    assignment = Assignment.find(params[:id])
    assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
    assignment.save

    params[:duplication].to_i.times do |i|
      j = i+1
      new_assignment = Assignment.find(params[:id]).dup
      new_assignment.uid = new_assignment.uid+"0"+j.to_s

      new_assignment.save
    end

    redirect_to(assignments_url(:loadtype => params[:loadtype]))
  end

  def fetch_all_document
    @app_assignment_max = AssignmentUpdate.maximum(:id)
    if(@app_assignment_max=='' || @app_assignment_max.nil?)
      @app_assignment_max = 0
    end

    @link = $urlpath.to_s+"sync/assignment_update/?id="+@app_assignment_max.to_s
    
    @response = [HTTParty.get(@link, format: :json).parsed_response]

    #because there is 2 [[]] at the json, use array[0][0] to access
    #the aray for each is refering to second [] then access the field such as 'id'
    @response[0][0].each do |response|
      @assignment_update = AssignmentUpdate.new

      @assignment_update.id = response['id']
      @assignment_update.uid = response['uid']
      @assignment_update.document_type = response['document_type']
      @assignment_update.document_path = response['document_path']
      @assignment_update.container = response['container']

      @assignment_update.save

      @id = 0;
      @uid = 0;
      @assignment = Assignment.where("uid = ?", @assignment_update.uid)
      @assignment.each do |assignment|

        #search for container
        count_container = Container.where("number = ?",@assignment_update.container).count
        if count_container != 0
          container = Container.where("number = ?",@assignment_update.container)
          container.each do |container|
            assignment.container_id = container.id
          end
        else
          create_container = Container.new

          create_container.number = @assignment_update.container
          create_container.size = assignment.containertype
          create_container.active = 1
          create_container.pol = CustomerLocation.find(assignment.pickup_location).location_id
          create_container.pod = CustomerLocation.find(assignment.destination_location).location_id

          create_container.save

          selected_container = Container.where("number = ?",@assignment_update.container)
          selected_container.each do |selected_container|
            assignment.container_id = selected_container.id
          end
        end

        @id = assignment.id
        @uid = assignment.uid

        if(@assignment_update.document_path!='')
          @link = $urlpath.to_s+"assets/uploads/"+@assignment_update.document_path
          
          if(@assignment_update.document_type==1)
            assignment.document_web_path = @link
          elsif (@assignment_update.document_type==2)
            assignment.dooring_web_path = @link
          elsif (@assignment_update.document_type==3)
            assignment.payment_web_path = @link
          end
        end
        
        assignment.status = response['status']

        if(response['description']!='')
          assignment.description = response['description']
        end

        assignment.save
        
      end
    end

    redirect_to(assignments_url(:loadtype => params[:loadtype]))
  end

  def sync_all_assignment
    @assignment = Assignment.where("(sync_at is NULL OR sync_at < edited_at) AND loadtype = 'Full Container Load'")
    
    if(params[:loadtype]==2)
      @assignment = Assignment.where("(sync_at is NULL OR sync_at < edited_at) AND loadtype = 'Less Container Load'")
    end

    @assignment.each do |assignment|
      @link = $urlpath.to_s+"sync/?"+
      "target=assignment"+
      "&id="+assignment.id.to_s+
      "&uid="+assignment.uid.to_s

      if !assignment.container_id.nil? && !Container.find(assignment.container_id).shipment_id.nil?
        @link += "&shipname="+Shipment.find(Container.find(assignment.container_id).shipment_id).shipname.to_s+
        Shipment.find(Container.find(assignment.container_id).shipment_id).voyage.to_s
      end

      @link += 
      "&pickup_agent="+assignment.agent.id.to_s+
      "&dooring_agent="+assignment.dooring_agent_id.to_s+
      "&customer="+assignment.customer.id.to_s

      if !assignment.container_id.nil?
        @link += "&container_number="+Container.find(assignment.container_id).number.to_s
      end
      
      if !assignment.pickup_location.nil?
    if  CustomerLocation.where("id = ?",assignment.pickup_location).count > 0
      @link += "&pickup_address="+CustomerLocation.find(assignment.pickup_location).address.to_s+
        "&pol="+Location.find(CustomerLocation.find(assignment.pickup_location).location_id).name.to_s
    else
      @link += "&pickup_address=null&pol=null"
    end
      end 

      if !assignment.destination_location.nil?
    if CustomerLocation.where("id = ?",assignment.destination_location).count > 0
      @link += "&destination_address="+CustomerLocation.find(assignment.destination_location).address.to_s+
        "&pod="+Location.find(CustomerLocation.find(assignment.destination_location).location_id).name.to_s
    else
      @link += "&pickup_address=null&pol=null"
    end
      end

      @link += "&pickuptime="+assignment.pickuptime.to_s(:long).to_s+
      "&load_type="+assignment.loadtype.to_s+
      "&container_type="+assignment.containertype.to_s+
      "&total_product="+AssignmentDetail.where("assignment_id = ?", assignment.id).count.to_s+
      "&total_price="+assignment.total_price.to_s+
      "&ppn="+assignment.ppn.to_s+
      "&grand_total="+assignment.grand_total.to_s+       
      "&active="+assignment.active.to_s       

      #saving sync datetime
      assignment.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
      if(assignment.edited_at.nil?)
        assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
      end

      @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

      assignment.description = @response['response']
      assignment.save
    end

    redirect_to(assignments_url(:loadtype => params[:loadtype]))
  end

  def sync_assignment
    @assignment = Assignment.find(params[:id])

    @link = $urlpath.to_s+"sync/?"+
    "target=assignment"+
    "&id="+@assignment.id.to_s+
    "&uid="+@assignment.uid.to_s

    if !@assignment.container_id.nil? && !Container.find(@assignment.container_id).shipment_id.nil?
      @link += "&shipname="+Shipment.find(Container.find(@assignment.container_id).shipment_id).shipname.to_s+
      Shipment.find(Container.find(@assignment.container_id).shipment_id).voyage.to_s
    end

    @link += 
    "&pickup_agent="+@assignment.agent.id.to_s+
    "&dooring_agent="+@assignment.dooring_agent_id.to_s+
    "&customer="+@assignment.customer.id.to_s

    if !@assignment.container_id.nil?
      @link += "&container_number="+Container.find(@assignment.container_id).number.to_s
    end
    
    if !@assignment.pickup_location.nil?
    if  CustomerLocation.where("id = ?",@assignment.pickup_location).count > 0
      @link += "&pickup_address="+CustomerLocation.find(@assignment.pickup_location).address.to_s+
    "&pol="+Location.find(CustomerLocation.find(@assignment.pickup_location).location_id).name.to_s
    else
      @link += "&pickup_address=null&pol=null"
    end
  end 

  if !@assignment.destination_location.nil?
    if CustomerLocation.where("id = ?",@assignment.destination_location).count > 0
      @link += "&destination_address="+CustomerLocation.find(@assignment.destination_location).address.to_s+
    "&pod="+Location.find(CustomerLocation.find(@assignment.destination_location).location_id).name.to_s
    else
      @link += "&pickup_address=null&pol=null"
    end
  end

    @link += "&pickuptime="+@assignment.pickuptime.to_s(:long).to_s+
    "&load_type="+@assignment.loadtype.to_s+
    "&container_type="+@assignment.containertype.to_s+
    "&total_product="+AssignmentDetail.where("@assignment_id = ?", @assignment.id).count.to_s+
    "&total_price="+@assignment.total_price.to_s+
    "&ppn="+@assignment.ppn.to_s+
    "&grand_total="+@assignment.grand_total.to_s+       
    "&active="+@assignment.active.to_s       

    #saving sync datetime
    @assignment.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
    if(@assignment.edited_at.nil?)
      @assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
    end

    @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

    @assignment.description = @response['response']
    @assignment.save

    redirect_to(assignments_url(:loadtype => params[:loadtype]))
  end

  def document_invoice
    @assignment = Assignment.find(params[:id])
  end

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
    @app_assignment_max = AssignmentUpdate.maximum(:id)
    if(@app_assignment_max=='' || @app_assignment_max.nil?)
      @app_assignment_max = 0
    end

    if Assignment.internet_connection
      @response = HTTParty.get($urlpath.to_s+"sync/assignment_update/", format: :json).parsed_response 
      @web_assignment_max = @response[0][0]['max_id']
      #@web_assignment_max = 0

      @unsync_assignment = (@web_assignment_max.to_i - @app_assignment_max.to_i)
    else
      @unsync_assignment = -1
    end

    @unsync_assignmentsfcl = Assignment.where("loadtype = 'Full Container Load' AND (sync_at is NULL OR sync_at < edited_at)")
    @unsync_assignmentslcl = Assignment.where("loadtype = 'Less Container Load' AND (sync_at is NULL OR sync_at < edited_at)")

    @assignmentsfcl = Assignment.where("loadtype = 'Full Container Load' AND active = 1").order("uid DESC")
    @assignmentslcl = Assignment.where("loadtype = 'Less Container Load' AND active = 1").order("uid DESC")
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
    @assignment = Assignment.find(params[:id])

    @assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")

    @assignment.save
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
          
          price = CustomerLocationPricelist.where("customer_location_id = ? and location_id = ? and expireddate >= ?", pickup_location, location, Date.today)
          container = @assignment.containertype
          priceused = 0
          ppncategory = 0

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

            ppncategory = price.ppncategory
          end

          @assignment.total_price = priceused

          if(ppncategory==1)
            @assignment.ppn = (1.1*priceused/100)
          else
            @assignment.ppn = 0
          end

          @assignment.grand_total = @assignment.total_price + @assignment.ppn

          loadtype = 1
          customer_id = @assignment.customer_id
        end

        if(priceused == 0)
          @assignment.active = 0
          @assignment.save

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

    @assignment = Assignment.find(params[:id])

    @assignment.active = 0;
    @assignment.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")

    @assignment.save;

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
      params.require(:assignment).permit(:container_id, :agent_id, :customer_id, :pickup_location, :destination_location, :uid, :pickuptime, :document_status, :payment_status, :loadtype, :containertype, :active, :ppn, :grand_total, :dooring_agent_id, :dooring_status, :status)
    end
end
