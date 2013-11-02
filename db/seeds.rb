# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
now = Time.now
100.times do |i|
  Episode.create!({name: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(3), notes: Faker::Lorem.paragraph(8), seconds: 123, published_at: now-i.days, position: i})
end
