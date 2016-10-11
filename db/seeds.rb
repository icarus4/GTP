# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

c = Company.find_or_create_by!(name: '好公司', status: 'active', description: '我的公司')
u = User.find_by(email: 'gtp@gmail.com') || User.create!(email: 'gtp@gmail.com', password: '12345678', password_confirmation: '12345678', company: c)

# cities = %w(台北市 新北市 基隆市 桃園市 新竹市 新竹縣 苗栗縣)
# cities.each { |city| City.find_or_create_by!(name: city) }

Brand.find_or_create_by!(company: c, name: '統一')

PartnerRole.find_or_create_by!(name: 'customer', chinese_name: "客戶")
PartnerRole.find_or_create_by!(name: 'supplier', chinese_name: "供應商")
PartnerRole.find_or_create_by!(name: 'manufacturer', chinese_name: "製造商")
PartnerRole.find_or_create_by!(name: 'logistics', chinese_name: "物流商")
PartnerRole.find_or_create_by!(name: 'exporter', chinese_name: "出口商")
PartnerRole.find_or_create_by!(name: 'responsibility', chinese_name: "責任廠商")
