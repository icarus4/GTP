# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.find_or_create_by!(name: '好公司', status: 'active', description: '我的公司')
u = User.find_by(email: 'gtp@gmail.com') || User.create!(email: 'gtp@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

cities = %w(台北市 新北市 基隆市 桃園市 新竹市 新竹縣 苗栗縣)
cities.each { |city| City.find_or_create_by!(name: city) }

l1 = c.locations.create!(city: City.first, address: '中山北路一段', name: '辦公室', holds_stock: false)
l2 = c.locations.create!(city: City.first, address: '中山北路二段', name: '倉庫1', holds_stock: true)
l3 = c.locations.create!(city: City.first, address: '中山北路三段', name: '倉庫2', holds_stock: true)

s1 = Supplier.find_or_create_by!(company: c, name: '我的供應商-1', status: 'active', email: 'service@supplier1.com')
s2 = Supplier.find_or_create_by!(company: c, name: '我的供應商-2', status: 'active', email: 'service@supplier2.com')
c1 = Customer.find_or_create_by!(company: c, name: '我的顧客-1', status: 'active', email: 'service@customer1.com')
c2 = Customer.find_or_create_by!(company: c, name: '我的顧客-2', status: 'active', email: 'service@customer2.com')

c1.locations.create!(city: City.first, address: '羅斯福路一段', name: '辦公室')
c1.locations.create!(city: City.first, address: '羅斯福路二段', name: '店面-1')
c1.locations.create!(city: City.first, address: '羅斯福路三段', name: '店面-2')

item1 = ItemType.find_or_create_by!(name: '安全帽', company: c)
item2 = ItemType.find_or_create_by!(name: '紅茶', company: c)
item3 = ItemType.find_or_create_by!(name: '酒', company: c)

b1 = Brand.find_or_create_by!(company: c, name: '統一')
b2 = Brand.find_or_create_by!(company: c, name: '統二')

i1 = Item.find_or_create_by!(company: c, supplier: s1, item_type: item1, brand: b1, name: 'iPhone 6s',      description: '好iPhone 6s，不買嗎？')
i2 = Item.find_or_create_by!(company: c, supplier: s2, item_type: item2, brand: b2, name: 'iPhone 6s plus', description: '好iPhone 6s plus，不買嗎？')
