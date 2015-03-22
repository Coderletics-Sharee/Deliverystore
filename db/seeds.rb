# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
CSV.foreach(Rails.root.join("db/seeds_data/deliveries.csv"), headers: true) do |row|
  Delivery.find_or_create_by(item: row[0], price: row[1], description: row[2], image_url: row[3])
end