class UsersController < ApplicationController
  def index
        @users = User.where("active = 1")
    end

    def show
      @user = User.find_by_id(params[:id])
    end

    def new
        @user = User.new
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            redirect_to user_url, notice: "Updated User."
        else
            render :edit
        end
    end

    def create
        @user = User.new(:name => "TEST")
        if @user.save
            redirect_to users_url, notice: "User succesfully created!" 
        else
            redirect_to users_url, notice: "Failed to created!" 
        end
    end

    def create_user
        #untuk berjalan element yang harus ada sepertinya email, password, dann password_confirmation
        @user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation], :name => params[:name], :username => params[:username])
        if @user.save
            redirect_to users_url, notice: "User succesfully created!" 
        else
            redirect_to users_url, notice: "Failed to created! "+@user.errors.to_s
        end
    end

    def delete_user
        #@user.destroy
        @user = User.find(params[:id])

        @user.active = 0
        @user.save

        respond_to do |format|
          format.html { redirect_to users_url, notice: "User was successfully destroyed." }
          format.json { head :no_content }
        end
    end
end
