class Api::V1::RentalsController < ApplicationController

  before_action :ensure_authenticated_request

  before_action :find_rental, only: [:show, :update]

  def index
    render jsonapi: Rental.includes(:bookings).all, status: 200
  end

  def show
    render jsonapi: @rental, status: 200
  end

  def update
    if @rental.update(rental_params)
      render jsonapi: @rental, status: 200
    else
      render jsonapi: @rental.errors, status: 403
    end
  end

  private

  def find_rental
    @rental = Rental.includes(:bookings).find(params[:id])
  end

  def rental_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(
      params, only: [:name, :daily_rate]
    )
  end
end
