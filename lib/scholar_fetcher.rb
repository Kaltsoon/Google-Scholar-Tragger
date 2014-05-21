module ScholarFetcher
	
	extend ActiveSupport::Concern

	require "nokogiri"
	require "open-uri"
	require "net/http"
	require "uri"

	def fetch_results_from(url)

		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Get.new(uri.request_uri)
		request["User-Agent"] = "Mozilla /5.0 (Compatible MSIE 9.0;Windows NT 6.1;WOW64; Trident/5.0)"

		response = http.request(request)

		doc = Nokogiri::HTML(response.body)
		
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