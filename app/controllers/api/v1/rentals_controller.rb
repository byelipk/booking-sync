class Api::V1::RentalsController < ApplicationController

  before_action :ensure_authenticated_request

  before_action :find_rental, only: :show

  def index
    render json: Rental.includes(:bookings).all, status: 200
  end

  def show
    render json: @rental, status: 200
  end

  private

  def find_rental
    @rental = Rental.includes(:bookings).find(params[:id])
  end
end
