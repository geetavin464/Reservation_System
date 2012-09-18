class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :name, :null => false
      t.integer :num_guests, :null => false
      t.datetime :start_time, :null => false

      t.timestamps
    end
  end
end
