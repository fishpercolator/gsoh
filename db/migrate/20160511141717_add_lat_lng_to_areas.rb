class AddLatLngToAreas < ActiveRecord::Migration
  def change
    remove_column :areas, :geography
    add_column :areas, :lat, :float
    add_column :areas, :lng, :float
  end
end
