module ArxivFetcher
	
	extend ActiveSupport::Concern

	require "nokogiri"
	require "open-uri"
	require "net/http"
	require "uri"

	def fetch_search_results(start, keyword)

		url = "http://export.arxiv.org/api/query?search_query=all:#{URI.parse(keyword)}&start=#{start}&max_results=40"

		uri = URI.parse(url)
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Get.new(uri.request_uri)

		response = http.request(request)

		puts response.body

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

end