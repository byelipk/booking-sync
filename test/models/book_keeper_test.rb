require 'test_helper'
require_dependency 'book_keeper'

class BookKeeperTest < ActiveSupport::TestCase

  def setup
    @book_keeper = BookKeeper.new(Fabricate.build(:booking))
  end

  test "it exits" do
    assert @book_keeper
  end

  test "Booking implements the days_booked interface" do
    assert_respond_to @book_keeper, :days_booked
  end

  test "Booking days_booked calculates number of days a booking covers" do
    Timecop.freeze(DateTime.now) do
      [5, 4, 20, 1, 9, 16, 3, 100, 200, 300, 364].each do |count|
        booking = Fabricate.create(:booking,
          start_at: DateTime.now,
          end_at: DateTime.now + count.days)

        @book_keeper = BookKeeper.new(booking)

        assert_equal count, @book_keeper.days_booked,
          "Exptected #{count} days to be okay, but it wasn't"
      end
    end
  end

end
