# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.find_or_create_by!(name: '好公司', status: 'active', description: '我的公司')
u = User.find_by(email: 'icarus4.chu@gmail.com') || User.create!(email: 'icarus4.chu@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

s1 = Supplier.find_or_create_by!(company: c, name: '我的供應商-1', status: 'active', email: 'service@supplier1.com')
s2 = Supplier.find_or_create_by!(company: c, name: '我的供應商-2', status: 'active', email: 'service@supplier2.com')
c1 = Customer.find_or_create_by!(company: c, name: '我的顧客-1', status: 'active', email: 'service@customer1.com')
c2 = Customer.find_or_create_by!(company: c, name: '我的顧客-2', status: 'active', email: 'service@customer2.com')

pt1 = ProductType.find_or_create_by!(name: '安全帽', company: c)
pt2 = ProductType.find_or_create_by!(name: '紅茶', company: c)
pt3 = ProductType.find_or_create_by!(name: '酒', company: c)

b1 = Brand.find_or_create_by!(company: c, name: '統一')
b2 = Brand.find_or_create_by!(company: c, name: '統二')

p1 = Product.find_or_create_by!(company: c, supplier: s1, product_type: pt1, brand: b1, name: 'iPhone 6s',      description: '好iPhone 6s，不買嗎？')
p2 = Product.find_or_create_by!(company: c, supplier: s2, product_type: pt2, brand: b2, name: 'iPhone 6s plus', description: '好iPhone 6s plus，不買嗎？')

w1 = WeightUnit.find_or_create_by!(company: c, name: '公克')
w2 = WeightUnit.find_or_create_by!(company: c, name: '公斤')
w3 = WeightUnit.find_or_create_by!(company: c, name: '台斤')
