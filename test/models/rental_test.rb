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

require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  test "Rental exists" do
    assert Rental.new
  end

  test "Rental implements the name interface" do
    assert_respond_to Rental.new, :name
  end

  test "Rental implements the daily_rate interface" do
    assert_respond_to Rental.new, :daily_rate
  end

  test "Rental implements the img_url interface" do
    assert_respond_to Rental.new, :img_url
  end

  test "Rental implements the bookings interface" do
    assert_respond_to Rental.new, :bookings
  end

  test "Rental must have a name" do
    rental = Fabricate.build(:rental, name: nil)
    rental.save

    assert_equal true, rental.errors.details.include?(:name)

    rental.name = "Work space"
    rental.save

    assert_equal false, rental.errors.details.include?(:name)
  end

  test "Rental must have a daily_rate" do
    rental = Fabricate.build(:rental, daily_rate: nil)
    rental.save

    assert_equal true, rental.errors.details.include?(:daily_rate)

    rental.daily_rate = 1000.75
    rental.save

    assert_equal false, rental.errors.details.include?(:daily_rate)
  end

  test "Rental daily_rate cannot be less than 0" do
    rental = Fabricate.build(:rental, daily_rate: -15.50)
    rental.save

    error_message = rental.errors.messages[:daily_rate]&.first

    assert error_message, "Expected error message, but it doesn't exist"
    assert_match "must be greater than or equal to 0.0", error_message

    rental.daily_rate = 10.00
    rental.save

    assert_equal false, rental.errors.messages.include?(:daily_rate)
  end

  test "default img_url set on create" do
    rental = Fabricate.build(:rental)
    rental.save

    assert_not_nil rental.img_url
  end
end
