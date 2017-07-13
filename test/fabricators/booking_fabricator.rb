# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  rental_id    :integer          not null
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  client_email :string           not null
#  price        :decimal(12, 2)   default(0.0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

Fabricator(:booking) do
  rental       { Fabricate.create(:rental) }
  client_email { Faker::Internet.email }
  start_at     { DateTime.now + 1.day }
  end_at       { |attrs| attrs[:start_at] + 2.days }
end
