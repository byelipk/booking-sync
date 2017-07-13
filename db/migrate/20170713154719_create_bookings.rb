class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.integer :rental_id,      null: false
      t.datetime :start_at,      null: false
      t.datetime :end_at,        null: false
      t.string :client_email,    null: false

      # NOTE: The strategy I am using to store money is to use
      # the decimal data type with two digits after the decimal
      # and 12 digits overall.
      #
      # See: https://stackoverflow.com/questions/3063968/string-decimal-or-float-datatype-for-price-field
      t.decimal :price, null: false, default: 0.00, scale: 2, precision: 12

      t.timestamps
    end

    add_index :bookings, :rental_id
    add_index :bookings, [:rental_id, :start_at, :end_at]
  end
end
