json.array!(@tasks) do |task|
  json.extract! task, :id, :description, :title, :task_type
  json.url task_url(task, format: :json)
end
