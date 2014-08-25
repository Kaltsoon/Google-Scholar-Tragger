class QueryScrollsController < ApplicationController

	def create
		query_id = params[:query_id]
		scrolls = ActiveSupport::JSON.decode(params[:scrolls])

		scrolls.each do |scroll|
			QueryScroll.create(location: scroll["location"], scroll_time: scroll["time"], scholar_query_id: query_id)
		end
	end

end