class Api::V1::BookingsController < ApplicationController
  def index
    render json: Bookingall, status: 200
  end
end
