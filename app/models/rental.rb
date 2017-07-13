# == Schema Information
#
# Table name: rentals
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  daily_rate :decimal(12, 2)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Rental < ApplicationRecord
  has_many :bookings

  validates :name, presence: true
  validates :daily_rate, presence: true,
                         numericality: { greater_than_or_equal_to: 0.0 }
end
