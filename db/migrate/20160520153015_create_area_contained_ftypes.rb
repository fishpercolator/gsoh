class CreateAreaContainedFtypes < ActiveRecord::Migration
  def change
    create_table :area_contained_ftypes do |t|
      t.references :area, index: true, foreign_key: true
      t.string :ftype
      t.string :subtype

      t.timestamps null: false
    end
  end
end
