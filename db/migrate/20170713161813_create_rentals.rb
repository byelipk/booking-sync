class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.string :name, null: false
      t.string :img_url

      # NOTE: Ensure consistency with Booking#price
      t.decimal :daily_rate, null: false, default: 0.00, scale: 2, precision: 12

      t.timestamps
    end

    add_index :rentals, :name
  end
end
