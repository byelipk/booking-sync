class BookKeeper
  SECONDS_IN_DAY = 3600
  HOURS_IN_DAY = 24

  attr_reader :booking

  def initialize(booking)
    @booking = booking
  end

  def days_booked
    if booking.end_at && booking.start_at
      ((booking.end_at - booking.start_at).to_i / SECONDS_IN_DAY) / HOURS_IN_DAY
    else
      0
    end
  end

  def set_price
    if booking.rental && days_booked
      booking.price = booking.rental.daily_rate * days_booked
    end
  end
end
