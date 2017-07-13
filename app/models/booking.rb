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

class Booking < ApplicationRecord
  SECONDS_IN_DAY = 3600
  HOURS_IN_DAY = 24

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
           :rental_period_within_the_year

  after_validation :set_price

 # Custom Validations
  def rental_date_cannot_be_in_the_past
    if start_at.present? && start_at < DateTime.now
      errors.add(:start_at, "can't be in the past")
    end
  end

  def minimum_rental_is_for_one_day
    if start_at.present? && end_at.present?
      if end_at < start_at + 1.day
        errors.add(:end_at, "must be at least for 1 day")
      end
    end
  end

  def rental_period_within_the_year
    if end_at.present? && end_at > 1.year.from_now
      errors.add(:out_of_range, "booking must be within the year")
    end
  end

  def days_booked
    if end_at && start_at
      ((end_at - start_at).to_i / SECONDS_IN_DAY) / HOURS_IN_DAY
    else
      0
    end
  end

  def set_price
    if rental && days_booked
      self.price = rental.daily_rate * days_booked
    end
  end

end
