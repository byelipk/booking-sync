# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[
  {name: "Kayacking in the Colorado River", rate: 2000},
  {name: "Helicopter Ride Down South", rate: 1250},
  {name: "Library", rate: 2},
  {name: "Red Sox Game", rate: 15},
  {name: "Ice Dancing With the Queen", rate: 500},
].each do |kv|
  rental = Rental.create(name: kv[:name], daily_rate: kv[:rate])
end
