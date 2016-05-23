# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  password_digest        :string           default(""), not null
#  company_id             :integer
#  name                   :string           default(""), not null
#  phone_number           :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password

  belongs_to :company

  validates :email,
            presence: true,
            confirmation: true,
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password_confirmation, presence: true

  def relationships
    Company.where(company_id: company_id)
  end

  def suppliers
    Supplier.where(company_id: company_id)
  end

  def customers
    Customers.where(company_id: company_id)
  end
end
