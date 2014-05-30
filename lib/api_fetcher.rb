module ApiFetcher

	extend ActiveSupport::Concern

	require "nokogiri"
	require "open-uri"
	require "net/http"
	require "uri"

	def fetch_search_results_from_arxiv(start, keyword)

		url = "http://export.arxiv.org/api/query?search_query=all:#{URI.parse(keyword)}&start=#{start}&max_results=40"

		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)

		doc = Nokogiri::XML(response.body)
		
		results = []

		doc.css("entry").each do |result| 
			title = result.css("title")[0].content
			link = result.css("id")[0].content
			authors_arr = []
			result.css("author").each do |author|
				authors_arr.push(author.content)
			end
			authors = authors_arr.join(", ")
			synopsis = result.css("summary")[0].content
			sitations = 0
			results.push({ title: title, link: link, synopsis: synopsis, authors: authors, sitations: sitations })
		end

		return results

	end

	def fetch_search_results_from_scholar(start, keyword)

		start = start.to_i
		start_end = start + 3

		pointer = start

		results = []
		for i in start..start_end
			results.concat fetch_single_from_scholar(pointer, keyword)
			pointer += 10
		end

		return results

	end

	private

		def fetch_single_from_scholar(start, keyword)

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

			puts url

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