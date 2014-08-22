class QueryScrollsController < ApplicationController

	def create
		query_id = params[:query_id]
		scrolls = ActiveSupport::JSON.decode(params[:scrolls])

		scrolls.each do |scroll|
			QueryScroll.create(start_position: scroll["start_position"], end_position: scroll["end_position"], start_time: scroll["start_time"], end_time: scroll["end_time"], scholar_query_id: query_id)
		end

		render json: { msg: QueryScroll.count }
	end

end