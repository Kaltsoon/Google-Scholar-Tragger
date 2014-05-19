module ScholarFetcher
	
	extend ActiveSupport::Concern

	require "nokogiri"
	require "open-uri"

	def fetch_results_from(url)
		doc = Nokogiri::HTML(open(url))
		
		results = []
		doc.css(".gs_ri").each do |result| 
			title = ( result.css("h3.gs_rt a").empty? ? nil : result.css("h3.gs_rt a")[0].content )
			link = ( result.css("h3.gs_rt a").empty? ? "#" : result.css("h3.gs_rt a")[0]["href"] )
			authors = ( result.css(".gs_a").empty? ? "" : result.css(".gs_a")[0].content )
			synopsis = ( result.css(".gs_rs").empty? ? "" : result.css(".gs_rs")[0].content )
			sitations = ( result.css(".gs_fl a:first-child").empty? ? 0 : result.css(".gs_fl a:first-child")[0].content.split(" ").last.to_i )
			if(not title.nil?)
				results.push({ title: title, link: link, synopsis: synopsis, authors: authors, sitations: sitations })
			end
		end

		return results
	end

end