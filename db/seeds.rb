# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  name: 'Felipe',
  email: 'flp.far@hotmail.com',
  password: '123123'
)

User.create(
  name: 'Sergio',
  email: 'sergio@xmail.com',
  password: '123123'
)

30.times do |i|
  User.create(
    name: "#{i} Faker::Name.name",
    email: "#{i}m@mail.com",
    password: '123123'
  )
end
