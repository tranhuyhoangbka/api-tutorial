# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 10.times do
#   Product.create! title: Faker::Name.title, price: Faker::Number.decimal(2), user_id: User.first.id
# end

20.times do
  order = Order.create! total: rand(10..100), user: User.all.sample
  order.products << Product.all.sample(rand(1..5))
end
