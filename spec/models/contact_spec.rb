# == Schema Information
#
# Table name: contacts
#
#  id               :integer          not null, primary key
#  contactable_type :string
#  contactable_id   :integer
#  name             :string           not null
#  title            :string
#  phone            :string
#  mobile           :string
#  fax              :string
#  email            :string
#  department       :string
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_contacts_on_contactable_type_and_contactable_id  (contactable_type,contactable_id)
#

require 'rails_helper'

RSpec.describe Contact, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
