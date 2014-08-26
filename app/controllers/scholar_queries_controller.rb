class ScholarQueriesController < ApplicationController
  
  include DataFormatter 

  before_action :set_scholar_query, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:create, :feedback]
  before_action :check_admin, only: [:show, :destroy, :index]

  # GET /scholar_queries
  # GET /scholar_queries.json
  def index
    @scholar_queries = ScholarQuery.all
  end

  def scholar_query
    render :query_form
  end

  # GET /scholar_queries/1
  # GET /scholar_queries/1.json
  def show
  end

  # GET /scholar_queries/new
  def new
    @scholar_query = ScholarQuery.new
  end

  # GET /scholar_queries/1/edit
  def edit
  end

  # POST /scholar_queries
  # POST /scholar_queries.json
  def create
    @scholar_query = ScholarQuery.new(query_text: params[:query_text], user_id: session[:user_id], task_report_id: params[:task_report_id], query_time: params[:query_time])
    @scholar_query.save
    render json: { id: @scholar_query.id }
  end

  # PATCH/PUT /scholar_queries/1
  # PATCH/PUT /scholar_queries/1.json
  def update
    respond_to do |format|
      if @scholar_query.update(scholar_query_params)
        format.html { redirect_to @scholar_query, notice: 'Scholar query was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @scholar_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scholar_queries/1
  # DELETE /scholar_queries/1.json
  def destroy
    @scholar_query.destroy
    respond_to do |format|
      format.html { redirect_to scholar_queries_url }
      format.json { head :no_content }
    end
  end

  def feedback
    query = ScholarQuery.find(params[:query_id])
    query.update(satisfaction: params[:satisfaction], broadness: params[:broadness])
  end

  #def download_data
  #  query = ScholarQuery.find(params[:query_id])
  #  data = "#{query.query_text},#{query.created_at},#{query.satisfaction_str},#{query.broadness_str}"
  #  send_data(data, filename: "#{query.query_text.gsub(/\s+/, "_")}_data.csv")
  #end

  def download_scroll_behavior
    query = ScholarQuery.find(params[:query_id])
    all_queries_in_task = query.task_report.scholar_queries
    send_data(query_scroll_behavior_data(query), filename: "q_#{all_queries_in_task.index(query) + 1}_scrolls.csv")
  end

  def download_clicks_timings
    query = ScholarQuery.find(params[:query_id])
    all_queries_in_task = query.task_report.scholar_queries

    send_data(query_clicks_timings_data(query), filename: "q_#{all_queries_in_task.index(query) + 1}_clicks.csv")
  end

  private

    def check_user
      if not is_user?
        redirect_to "/login"
      end
    end

    def check_admin
      if not is_admin?
        redirect_to "/login"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_scholar_query
      @scholar_query = ScholarQuery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scholar_query_params
      params.require(:scholar_query).permit(:query_text)
    end
end
