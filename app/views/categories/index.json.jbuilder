json.array!(@categories) do |category|
  json.extract! category, :id, :user_id, :name, :is_income
  json.url category_url(category, format: :json)
end
