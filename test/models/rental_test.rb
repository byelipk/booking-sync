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

  test "Rental implements the bookings interface" do
    assert_respond_to Rental.new, :bookings
  end
end
