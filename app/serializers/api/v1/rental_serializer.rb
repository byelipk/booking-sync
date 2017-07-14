class Api::V1::RentalSerializer < ActiveModel::Serializer
  attributes :id, :name, :daily_rate

  has_many :bookings
end
