json.array!(@policies) do |policy|
  json.extract! policy, :id, :number, :status, :code, :name, :effective
  json.url policy_url(policy, format: :json)
end
