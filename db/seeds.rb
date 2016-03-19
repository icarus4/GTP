# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.create!(name: '好公司', relationship_type: 'self', status: 'active', description: '我的公司')
u = User.create!(email: 'icarus4.chu@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

supplier1 = c.companies.create!(name: '我的供應商-1', relationship_type: 'supplier', status: 'active')
supplier2 = c.companies.create!(name: '我的供應商-2', relationship_type: 'supplier', status: 'active')
bc1 = c.companies.create!(name: '我的顧客-1', relationship_type: 'business_customer', status: 'active')
bc2 = c.companies.create!(name: '我的顧客-2', relationship_type: 'business_customer', status: 'active')
