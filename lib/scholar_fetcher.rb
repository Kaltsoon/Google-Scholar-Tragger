module ScholarFetcher
	
	extend ActiveSupport::Concern

	require "nokogiri"
	require "open-uri"
	require "net/http"
	require "uri"

	def fetch_search_results(start, keyword)

		start = start.to_i
		start_end = start + 3

		results = []
		for i in start..start_end
			results.concat fetch_single(i, keyword)
		end

		return results

	end

	private

		def fetch_single(start, keyword)

			url = ""
			if start == 0
				url = "http://scholar.google.fi/scholar?hl=en&q=#{keyword}"
			else
				url = "http://scholar.google.fi/scholar?start=#{start}&q=#{keyword}"
			end

			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)

			request = Net::HTTP::Get.new(uri.request_uri)
			request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0"

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