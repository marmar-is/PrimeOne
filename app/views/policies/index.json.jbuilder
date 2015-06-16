json.array!(@policies) do |policy|
  json.extract! policy, :id, :number, :code, :name, :effective, :status, :broker_id
  json.url policy_url(policy, format: :json)
end
