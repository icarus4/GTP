# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.create!(name: '好公司', status: 'active', description: '我的公司')
u = User.create!(email: 'icarus4.chu@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

s1 = c.suppliers.create!(name: '我的供應商-1', status: 'active', email: 'service@supplier1.com')
s2 = c.suppliers.create!(name: '我的供應商-2', status: 'active', email: 'service@supplier2.com')
c1 = c.customers.create!(name: '我的顧客-1', status: 'active', email: 'service@customer1.com')
c2 = c.customers.create!(name: '我的顧客-2', status: 'active', email: 'service@customer2.com')
