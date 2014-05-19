json.array!(@scholar_queries) do |scholar_query|
  json.extract! scholar_query, :id, :quering_time, :query_text
  json.url scholar_query_url(scholar_query, format: :json)
end
