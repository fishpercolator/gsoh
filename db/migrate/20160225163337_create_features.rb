class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :type
      t.string :subtype
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
end
