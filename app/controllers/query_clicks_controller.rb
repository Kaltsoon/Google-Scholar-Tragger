class QueryClicksController < ApplicationController
  before_action :set_query_click, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:create]

  # GET /query_clicks
  # GET /query_clicks.json
  def index
    @query_clicks = QueryClick.all
  end

  # GET /query_clicks/1
  # GET /query_clicks/1.json
  def show
  end

  # GET /query_clicks/new
  def new
    @query_click = QueryClick.new
  end

  # GET /query_clicks/1/edit
  def edit
  end

  # POST /query_clicks
  # POST /query_clicks.json
  def create
    @query_click = QueryClick.new(scholar_query_id: params[:scholar_query_id], heading: params[:heading], synopsis: params[:synopsis], link_location: params[:link_location], sitations: params[:sitations], location: params[:location], authors: params[:authors])
    @query_click.save
  end

  # PATCH/PUT /query_clicks/1
  # PATCH/PUT /query_clicks/1.json
  def update
    respond_to do |format|
      if @query_click.update(query_click_params)
        format.html { redirect_to @query_click, notice: 'Query click was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @query_click.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_clicks/1
  # DELETE /query_clicks/1.json
  def destroy
    @query_click.destroy
    respond_to do |format|
      format.html { redirect_to query_clicks_url }
      format.json { head :no_content }
    end
  end

  private

    def check_user
      if not is_user?
        redirect_to "/login"
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_query_click
      @query_click = QueryClick.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_click_params
      params.require(:query_click).permit(:scholar_query_id, :heading, :synopsis, :link_location, :sitations, :location)
    end
end
