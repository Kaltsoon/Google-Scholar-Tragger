json.array!(@query_clicks) do |query_click|
  json.extract! query_click, :id, :scholar_query_id, :heading, :synopsis, :link_location, :sitations, :click_time
  json.url query_click_url(query_click, format: :json)
end
