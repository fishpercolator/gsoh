class AddIndexesToFeatures < ActiveRecord::Migration
  def change
    add_index :features, :ftype
    add_index :features, [:ftype, :subtype]
  end
end
