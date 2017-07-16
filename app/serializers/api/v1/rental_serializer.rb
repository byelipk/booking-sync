class Api::V1::RentalSerializer < ActiveModel::Serializer
  attributes :id, :name, :daily_rate, :img_url

  has_many :bookings
end
