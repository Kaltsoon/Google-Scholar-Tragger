module DataFormatter
	
	extend ActiveSupport::Concern

	def query_clicks_timings_data(query)
		clicks = query.query_clicks.order(:location)
		data = "id,cumulated_clicks,title,start_click_time,end_click_time,duration\n"
		
		if( clicks.last.nil? )
			return data;
		end

		cumulation = 0
		iterator = 1

		for l in 1..clicks.last.location
			click_in_location = clicks.find_by(location: l) 

			if( click_in_location.nil? )
				data += "#{iterator},#{cumulation},?,-1,-1,-1\n"
			else
				cumulation = cumulation + 1
				data += "#{iterator},#{cumulation},#{click_in_location.heading},#{format_date(click_in_location.click_time) || format_date(click_in_location.created_at)},#{format_date(click_in_location.end_time)},#{click_in_location.duration}\n"
			end

			iterator = iterator + 1
		end

		return data
	end

	def query_scroll_behavior_data(query)
		scrolls = query.query_scrolls;
		data = "position,time\n"

		scrolls.each do |scroll|
			data += "#{scroll.location},#{format_date(scroll.scroll_time)}\n"
		end

		return data
	end

	def task_report_summary(task)
		t = task.task

		data = "start_time,end_time,duration_seconds,answer,task_description,result_item_height,search_form_height,result_items_count\n"
		data += "#{format_date(task.started) || format_date(task.created_at)},#{format_date(task.completed)},#{task.duration},#{task.minimal_report},#{t.title} - #{t.task_type},#{task.item_height},#{task.form_height},#{task.items}"
		return data
	end

	def task_report_queries_data(task)
		queries = task.scholar_queries.order(query_time: :desc)
	    data = "query,time,satisfaction,specificity\n"

	    queries.each do |query|
	    	data += "#{query.query_text},#{format_date(query.query_time) || format_date(query.created_at)},#{query.satisfaction_str},#{query.broadness_str}\n"
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

	private

		def format_date(date)
			date.strftime('%Y-%m-%d %H:%M:%S') unless date.nil?
		end
end