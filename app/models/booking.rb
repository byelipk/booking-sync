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

require_dependency 'book_keeper'
require_dependency 'booking_validator'

class Booking < ApplicationRecord

  belongs_to :rental

  validates :start_at,
    presence: true

  validates :end_at,
    presence: true

  validates :client_email,
    presence: true,
    format: { with: /@/ }

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0.0 }

  validate :rental_date_cannot_be_in_the_past,
           :minimum_rental_is_for_one_day,
           :rental_period_within_the_year,
           :booking_does_not_overlap

  delegate :minimum_rental_is_for_one_day,
           :rental_date_cannot_be_in_the_past,
           :rental_period_within_the_year,
           :booking_does_not_overlap,
           to: :booking_validator

  after_validation :set_price
  
  delegate :set_price, to: :book_keeper

  def book_keeper
    @book_keeper ||= BookKeeper.new(self)
  end

  def booking_validator
    @booking_validator ||= BookingValidator.new(self)
  end

end
