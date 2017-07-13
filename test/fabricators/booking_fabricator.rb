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
  start_at     { DateTime.now + 1.day  }
  end_at       { DateTime.now + 2.days }
  client_email { Faker::Internet.email }
  price        { |attrs| attrs[:rental].daily_rate * 1 }
end
