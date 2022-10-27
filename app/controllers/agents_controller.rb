class AgentsController < ApplicationController
  before_action :set_agent, only: %i[ show edit update destroy ]

  def sync_all_agent
    @agent = Agent.where("(sync_at is NULL OR sync_at < edited_at) AND active = 1")

    @agent.each do |agent|
      @link = "http://jstranslogistik.com/sync/?"+
      "target=agent"+
      "&id="+agent.id.to_s+
      "&name="+agent.name.to_s+
      "&pickupordooring="+agent.pickupordooring.to_s+
      "&active="+agent.active.to_s

      @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

      agent.description = @response['response']

      if(@response['response']=="ok")
        #saving sync datetime
        agent.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
        if(agent.edited_at.nil?)
          agent.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
        end
      end

      agent.save
    end

    redirect_to(agents_url)
  end

  def sync_agent
    @agent = Agent.find(params[:id])

    @link = "http://jstranslogistik.com/sync/?"+
    "target=agent"+
    "&id="+@agent.id.to_s+
    "&name="+@agent.name.to_s+
    "&pickupordooring="+@agent.pickupordooring.to_s+
    "&active="+@agent.active.to_s

    @response = HTTParty.get(@link.to_s, format: :json).parsed_response 

    @agent.description = @response['response']

    if(@response['response']=="ok")
      #saving sync datetime
      @agent.sync_at = Time.now.strftime("%d/%m/%Y %H:%M")
      if(@agent.edited_at.nil?)
        @agent.edited_at = Time.now.strftime("%d/%m/%Y %H:%M")
      end
    end

    @agent.save

    redirect_to(agents_url)
  end

  # GET /agents or /agents.json
  def index
    @agents = Agent.where("active = 1")

    @unsync_agents = Agent.where("(sync_at is NULL OR sync_at < edited_at) AND active = 1")
  end

  # GET /agents/1 or /agents/1.json
  def show
  end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents or /agents.json
  def create
    @agent = Agent.new(agent_params)

    respond_to do |format|
      if @agent.save
        format.html { redirect_to agents_path, notice: "Agent was successfully created." }
        format.json { render :show, status: :created, location: @agent }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agents/1 or /agents/1.json
  def update
    respond_to do |format|
      if @agent.update(agent_params)
        format.html { redirect_to agents_path, notice: "Agent was successfully updated." }
        format.json { render :show, status: :ok, location: @agent }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agents/1 or /agents/1.json
  def destroy
    @agent = Agent.find(params[:id])

    @agent.active = 0
    @agent.save

    respond_to do |format|
      format.html { redirect_to agents_url, notice: "Agent was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agent_params
      params.require(:agent).permit(:name, :address, :contact, :pickupordooring, :active, :description)
    end
end
