class BookingValidator
  attr_reader :booking

  def initialize(booking)
    @booking = booking
  end

  # Custom Validations
   def rental_date_cannot_be_in_the_past
     if booking.start_at.present? && booking.start_at < DateTime.now
       booking.errors.add(:start_at, "can't be in the past")
     end
   end

   def minimum_rental_is_for_one_day
     if booking.start_at.present? && booking.end_at.present?
       if booking.end_at < booking.start_at + 1.day
         booking.errors.add(:end_at, "must be at least for 1 day")
       end
     end
   end

   def rental_period_within_the_year
     if booking.end_at.present? && booking.end_at > 1.year.from_now
       booking.errors.add(:out_of_range, "booking must be within the year")
     end
   end
end
