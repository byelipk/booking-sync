class Api::V1::RentalsController < ApplicationController

  before_action :ensure_authenticated_request

  before_action :find_rental, only: [:show, :update, :destroy]

  def index
    if params[:query]
      render(
        jsonapi: Rental.where(
          "similarity(name, ?) > 0.1", params[:query]),
        status: 200
      )
    else
      render jsonapi: Rental.all, status: 200
    end
  end

  def show
    render jsonapi: @rental, status: 200
  end

  def update
    if @rental.update(rental_params)
      render jsonapi: @rental, status: 200
    else
      render jsonapi: @rental,
        status: 422,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def create
    rental = Rental.new(rental_params)

    if rental.save
      render jsonapi: rental, status: 201
    else
      render jsonapi: rental,
        status: 422,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    if @rental.destroy
      head 200
    else
      head 422
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
