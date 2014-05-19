class ApiController < ApplicationController

	include ScholarFetcher

	def user_search

		user = User.all.find_by_token(params[:token])

		if !user.nil?
			session[:user_id] = user.id
			render :index
		else
			redirect_to "/login"
		end

	end

	def scholar_query
		keyword = URI::encode(params[:keyword])
		start = params[:start]
		if start == 0
			url = "http://scholar.google.fi/scholar?hl=en&q=#{keyword}"
		else
			url = "http://scholar.google.fi/scholar?start=#{start}&q=#{keyword}"
		end
		render json: { results: fetch_results_from(url) }
	end

end