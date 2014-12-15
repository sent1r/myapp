json.array!(@incomes) do |income|
  json.extract! income, :id, :user_id, :category_id, :name, :cost
  json.url income_url(income, format: :json)
end
