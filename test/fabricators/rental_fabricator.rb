# == Schema Information
#
# Table name: rentals
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  img_url    :string
#  daily_rate :decimal(12, 2)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

Fabricator(:rental) do
  name "iPod"
  daily_rate 100.00
end
