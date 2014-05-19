class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:show, :destroy, :new, :create, :index]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
  
    token = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
    until(User.all.find_by_token(token).nil?)
      token = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
    end

    @user = User.new(name: params[:user][:name], token: token)
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end

  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def admin_login
    if( not session[:admin_id].nil? )
      redirect_to scholar_queries_path
    else
      render :login
    end
  end

  def admin_login_check
    a = Admin.all.where(name: params[:admin][:name]).first
    if(!a.nil? and a.authenticate params[:admin][:password])
      session[:admin_id] = a.id
      redirect_to scholar_queries_path
    else
      redirect_to "/login", notice: "Wrong name or password!"
    end
  end

  def admin_logout
    session[:admin_id] = nil
    redirect_to "/login"
  end

  private

    def check_admin
      if not is_admin?
        redirect_to "/login"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :token)
    end
end
