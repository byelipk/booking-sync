class Api::V1::BookingsController < ApplicationController
  before_action :ensure_authenticated_request

  before_action :find_rental, only: [:create]
  before_action :find_booking, only: [:show, :update, :destroy]

  def index
    if params[:include] == "rentals"
      bookings = Booking.includes(:rental).all

      render(
        jsonapi: bookings,
        include: [:rental],
        status: 200 )
    else
      render jsonapi: Booking.all, status: 200
    end
  end

  def show
    render jsonapi: @booking, status: 200
  end

  def update
    if @booking.update(booking_params)
      render jsonapi: @booking, status: 200
    else
      render jsonapi: @booking,
        status: 422,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def create
    booking = @rental.bookings.build(booking_params)

    if booking.save
      render jsonapi: booking, status: 201
    else
      render jsonapi: booking,
        status: 422,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    if @booking.destroy
      head 204
    else
      head 422
    end
  end

  private

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def find_rental
    @rental = Rental.find(booking_params[:rental_id])
  end

  def booking_params
    @booking_params ||= ActiveModelSerializers::Deserialization.jsonapi_parse!(
      params, only: [:start_at, :end_at, :client_email, :price, :rental]
    )
  end

end
