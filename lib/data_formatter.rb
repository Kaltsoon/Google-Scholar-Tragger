module DataFormatter
	
	extend ActiveSupport::Concern

	def query_clicks_timings_data(query)
		clicks = query.query_clicks
		data = ""

		clicks.each do |click|
			data += "#{click.heading},#{click.created_at},#{click.end_time},#{click.duration}\n"
		end

		return data
	end

	def query_scroll_behavior_data(query)
		scrolls = query.query_scrolls;
		data = ""

		scrolls.each do |scroll|
			data += "#{scroll.location},#{scroll.scroll_time}"
		end

		return data
	end

	def task_report_summary(task)
		return "#{task.created_at},#{task.completed},#{task.duration},#{task.report}"
	end

	def task_report_queries_data(task)
		queries = task.scholar_queries
	    data = ""

	    queries.each do |query|
	    	data += "#{query.query_text},#{query.created_at},#{query.satisfaction_str},#{query.broadness_str}\n"
	    end

	    return data
	end

	def task_report_clicks_data(task)
		queries = task.scholar_queries
		query_clicks = {}
      	query_counter = 0
      	data = ""

      	queries.each do |query|
	        query_clicks[query.id] = 0
	        data += "#{query.query_text},"
	        query_counter = query_counter + 1
     	end

     	data = data[0,data.length-1]
      	data += "\n"

      	for round in 1..40
        	round_values = ""
        	queries.each do |query|
	          	click_time = "-1"
	          	
	          	unless QueryClick.where(scholar_query_id: query.id, location: round).empty?
	            	query_clicks[query.id] = query_clicks[query.id] + 1
	            	click_time = QueryClick.where(scholar_query_id: query.id, location: round).first.created_at.to_s
	          	end
	            
	            round_values += "#{query_clicks[query.id].to_s},"
	        end

        	data += round_values[0,round_values.length-1]
        	data += "\n"
     	 end

      	return data
	end

end