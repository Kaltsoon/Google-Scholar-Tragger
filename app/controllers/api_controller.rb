class ApiController < ApplicationController

	include ApiFetcher

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

		if(params[:resource] == "scholar")
			render json: { results: fetch_search_results_from_scholar(start, keyword) }
		else
			render json: { results: fetch_search_results_from_arxiv(start, keyword) }
		end

	end

end