# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

1000.times do
  Contact.create :name => "#{Faker::Name.first_name} #{Faker::Name.last_name}", :mobile => "#{Faker::PhoneNumber.phone_number}", :voip => "#{Faker::PhoneNumber.phone_number}"
end