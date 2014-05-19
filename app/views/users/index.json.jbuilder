json.array!(@users) do |user|
  json.extract! user, :id, :name, :token
  json.url user_url(user, format: :json)
end
