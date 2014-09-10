class UsersController < ApplicationController
  include DataFormatter

  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :check_admin, only: [:show, :destroy, :new, :create, :index, :download_data]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.includes(task_reports: [:task, :scholar_queries]).find(params[:id])
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

  def download_zip
    user = User.find(params[:user_id])

    if(params[:content] == 'clicks_no_time')
      clicks_no_time_zip(user)
    elsif(params[:content] == 'clicks_with_time')
      clicks_with_time_zip(user)
    elsif(params[:content] == 'queries')
      queries_zip(user)
    elsif(params[:content] == 'scroll')
      scroll_zip(user)
    else
      summaries_zip(user)
    end
  end

  def download_data

    user = User.find(params[:user_id])

    if(params[:include] == "query_clicks_and_timings")
      send_data(get_query_clicks_data(params[:user_id], true), filename: "#{user.name.gsub(/\s+/, "_")}_data.csv")
    elsif(params[:include] == "query_clicks")
      send_data(get_query_clicks_data(params[:user_id], false), filename: "#{user.name.gsub(/\s+/, "_")}_data.csv")
    elsif(params[:include] == "query_scroll_behavior")
      send_data(get_query_scroll_behavior(params[:user_id]), filename: "#{user.name.gsub(/\s+/, "_")}_data.csv")
    else
      send_data(get_query_data(params[:user_id]), filename: "#{user.name.gsub(/\s+/, "_")}_data.csv")
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

    def get_query_data(user_id)
      user = User.find(user_id)
      queries = user.scholar_queries
      
      data = ""
      queries.each do |query|
        data += "#{query.query_text},#{query.created_at},#{query.satisfaction_str},#{query.broadness_str}\n"
      end

      return data

    end

    def get_query_scroll_behavior(user_id)
      queries = User.find(user_id).scholar_queries
      data = ""
      query_counter = 0
      
      queries.each do |query|
        data += "#{query.query_text},t#{query_counter}\n"
        query.query_scrolls.each do |scroll|
          data += "#{scroll.location},#{scroll.scroll_time}\n"
        end
      end

      return data
    end

    def get_query_clicks_data(user_id, timings)
      user = User.find(user_id)

      data = ""

      queries = user.scholar_queries
      query_clicks = {}
      query_counter = 0
      queries.each do |query|
        query_clicks[query.id] = 0
        if(timings)
          data += "#{query.query_text},t#{query_counter},#{query.broadness_str},#{query.satisfaction_str}"
        else
          data += "#{query.query_text},"
        end
        query_counter = query_counter + 1
      end

      data = data[0,data.length-1]
      data += "\n"

      for round in 1..40
        round_values = ""

        queries.each do |query|
          
          click_time = "-1"

          if( not QueryClick.where(scholar_query_id: query.id, location: round).empty? )
            query_clicks[query.id] = query_clicks[query.id] + 1
            click_time = QueryClick.where(scholar_query_id: query.id, location: round).first.created_at.to_s
          end
          if(timings)
            round_values += "#{query_clicks[query.id].to_s},#{click_time},"
          else
            round_values += "#{query_clicks[query.id].to_s},"
          end
        end

        data += round_values[0,round_values.length-1]
        data += "\n"
      end

      return data

    end

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
