class Reservation < ActiveRecord::Migration
  def up
      add_column :reservations, :table_reserved, :integer, :null => false
  end

  def down
      remove_column :reservations, :table_reserved
  end
end
