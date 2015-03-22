json.array!(@deliveries) do |delivery|
  json.extract! delivery, :id, :item, :price, :description, :image_url
  json.url delivery_url(delivery, format: :json)
end
