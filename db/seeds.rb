# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.find_or_create_by!(name: '好公司', status: 'active', description: '我的公司')
u = User.find_by(email: 'gtp@gmail.com') || User.create!(email: 'gtp@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

Location.find_or_create_by!(locationable: c, name: '辦公室', holds_stock: false, address: '台北市')
Location.find_or_create_by!(locationable: c, name: '倉庫1', holds_stock: true, address: '台北市')
Location.find_or_create_by!(locationable: c, name: '倉庫2', holds_stock: true, address: '新北市')

# cities = %w(台北市 新北市 基隆市 桃園市 新竹市 新竹縣 苗栗縣)
# cities.each { |city| City.find_or_create_by!(name: city) }

customer       = PartnerRole.find_or_create_by!(name: 'customer', chinese_name: "客戶")
supplier       = PartnerRole.find_or_create_by!(name: 'supplier', chinese_name: "供應商")
manufacturer   = PartnerRole.find_or_create_by!(name: 'manufacturer', chinese_name: "製造商")
logistics      = PartnerRole.find_or_create_by!(name: 'logistics', chinese_name: "物流商")
exporter       = PartnerRole.find_or_create_by!(name: 'exporter', chinese_name: "出口商")
responsibility = PartnerRole.find_or_create_by!(name: 'responsibility', chinese_name: "責任廠商")

p = Partner.find_or_create_by!(company: c, name: '統一', partner_type: 'domestic_company')
p.roles = [customer, supplier, manufacturer, logistics, exporter]
Location.find_or_create_by!(locationable: p, name: '辦公室', holds_stock: false, address: '台北市')

brand = Brand.find_or_create_by!(company: c, name: '可口可樂')
ItemSeries.find_or_create_by!(company: c, name: '可口可樂', brand: brand, manufacturer: p, storage_and_transport_condition: 'room_temperature')
