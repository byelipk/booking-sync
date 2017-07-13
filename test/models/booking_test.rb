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

require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test "it exists" do
    assert Booking.new
  end

  test "Booking implements the start_at interface" do
    assert_respond_to Booking.new, :start_at
  end

  test "Booking implements the end_at interface" do
    assert_respond_to Booking.new, :end_at
  end

  test "Booking implements the client_email interface" do
    assert_respond_to Booking.new, :client_email
  end

  test "Booking implements the price interface" do
    assert_respond_to Booking.new, :price
  end

  test "Booking implements the rental interface" do
    assert_respond_to Booking.new, :rental
  end

  test "Booking must have start_at and end_at dates" do
    booking = Fabricate.build(:booking, start_at: nil, end_at: nil)
    booking.save

    assert_equal true, booking.errors.messages.include?(:start_at)
    assert_equal true, booking.errors.messages.include?(:end_at)

    booking.start_at = DateTime.now.utc + 1.day
    booking.end_at = DateTime.now.utc + 2.days
    booking.save

    assert_equal false, booking.errors.messages.include?(:start_at)
    assert_equal false, booking.errors.messages.include?(:end_at)
  end

  test "Booking start_at cannot be in the past" do
    Timecop.freeze(DateTime.now.utc) do
      booking = Fabricate.build(:booking, start_at: DateTime.now.utc - 1.second)
      booking.save

      assert_equal true, booking.errors.messages.include?(:start_at)

      booking.start_at = DateTime.now.utc - 1.day
      booking.save

      assert_equal true, booking.errors.messages.include?(:start_at)

      booking.start_at = DateTime.now.utc + 1.second
      booking.save

      assert_equal false, booking.errors.messages.include?(:start_at)
    end
  end

  test "Booking must be at least for 24 hours" do
    Timecop.freeze(DateTime.now) do
      booking = Fabricate.build(:booking,
        start_at: DateTime.now,
        end_at: DateTime.now + 1439.minutes)

      booking.save

      assert_equal true, booking.errors.messages.include?(:end_at),
        "Expected a validation error on end_at, but there wasn't one"

      booking.end_at = DateTime.now + 1.day
      booking.save

      assert_equal false, booking.errors.messages.include?(:end_at),
        "Did not expect a validation error on end_at, but there was one"
    end
  end

  test "Booking must have valid client email" do
    booking = Fabricate.build(:booking, client_email: "not-an-email.com")
    booking.save

    assert_equal true, booking.errors.messages.include?(:client_email),
      "Expected to validate client email, but did not"

    booking.client_email = "hello@world.com"
    booking.save

    assert_equal false, booking.errors.messages.include?(:client_email),
      "Expected client email to be okay, but it was not"
  end

  test "Booking must have a price" do
    booking = Fabricate.build(:booking, price: nil)
    booking.save

    assert_equal true, booking.errors.details.include?(:price)

    booking.price = 1000
    booking.save

    assert_equal false, booking.errors.details.include?(:price)
  end

  test "Booking implements the days_booked interface" do
    assert_respond_to Booking.new, :days_booked
  end

  test "Booking days_booked calculates number of days a booking covers" do
    Timecop.freeze(DateTime.now) do
      right_now = DateTime.now
      [5, 4, 20, 1, 9, 16, 3, 100, 200, 300, 364].each do |count|
        booking = Fabricate.create(:booking,
          start_at: right_now,
          end_at: right_now + count.days)

        assert_equal count, booking.days_booked,
          "Exptected #{count} days to be okay, but it wasn't"
      end
    end
  end

  test "Booking period is within the year" do
    Timecop.freeze(DateTime.now) do
      right_now = DateTime.now
      booking = Fabricate.build(:booking,
        start_at: right_now,
        end_at: right_now + 366.days)

      booking.save

      assert_includes booking.errors.messages, :out_of_range,
        "Expected the date to be out of range, but it wasn't"
    end
  end

  test "Booking price is set when the booking is created" do
    Timecop.freeze(DateTime.now) do
      rental = Fabricate.create(:rental,
        name: "Kayaak",
        daily_rate: 500.00)

      booking = Fabricate.create(:booking,
        rental: rental,
        start_at: DateTime.now,
        end_at: DateTime.now + 2.days)

      assert_equal 1000, booking.price.to_i
    end
  end
end
