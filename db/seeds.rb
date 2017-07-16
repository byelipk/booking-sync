# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


[
  {name: "Kayacking in the Colorado River", rate: 2000, img_url: "https://a0.muscache.com/im/pictures/e7a377a9-9a07-41af-8a21-cf933c29b791.jpg?aki_policy=poster"},
  {name: "Helicopter Ride", rate: 1250, img_url: "https://a0.muscache.com/im/pictures/03ee2ce2-782e-42f3-b3c2-7cf85b3cd6c9.jpg?aki_policy=poster"},
  {name: "Library Visit", rate: 2, img_url: "https://a0.muscache.com/im/pictures/707a7efa-90e2-440e-88a8-916d1f291ede.jpg?aki_policy=poster"},
  {name: "Red Sox Game", rate: 15, img_url: "https://a0.muscache.com/im/pictures/56d23756-b70b-440c-a081-5ccc24a6c047.jpg?aki_policy=poster"},
  {name: "Dance with the Ice Queen", rate: 500, img_url: "https://a0.muscache.com/im/pictures/aa0cf07e-07dc-4ca5-ac88-73b9997f7b80.jpg?aki_policy=poster"},
  {name: "Walk to the Holywood Hills", rate: 50, img_url: "https://a0.muscache.com/im/pictures/ee528d90-e9bf-4c9d-9dde-9150b2956e38.jpg?aki_policy=poster"},
  {name: "Learn to cook Japanese food", rate: 25, img_url: "https://a0.muscache.com/im/pictures/6acf36e0-cf9a-4433-9339-26d7b4e8e18a.jpg?aki_policy=poster"},
  {name: "Hobbit Mansion", rate: 1150, img_url: "https://a0.muscache.com/im/pictures/15525b73-c222-44c6-b1f8-483c6d049d73.jpg?aki_policy=poster"},
  {name: "The White House", rate: 1, img_url: "https://a0.muscache.com/im/pictures/b11cafba-6e13-4584-ba2a-243cfa28c160.jpg?aki_policy=poster"},
  {name: "Clifton Beach Apartment", rate: 175, img_url: "https://a0.muscache.com/im/pictures/d0b28e17-7c02-403b-8a9a-ae6c3cb61f5e.jpg?aki_policy=poster"},
].each do |kv|
  rental = Rental.create(name: kv[:name], daily_rate: kv[:rate], img_url: kv[:img_url])
end
