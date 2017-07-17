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

class Rental < ApplicationRecord
  has_many :bookings

  validates :name, presence: true
  validates :daily_rate, presence: true,
                         numericality: { greater_than_or_equal_to: 0.0 }

  before_create :set_default_img_url

  def set_default_img_url
    self.img_url = "https://a0.muscache.com/im/pictures/1e172922-0a58-4641-8700-2b65709b4734.jpg?aki_policy=poster"
  end
end
