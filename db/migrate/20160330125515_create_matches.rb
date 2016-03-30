class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :user, index: true, foreign_key: true
      t.references :area, index: true, foreign_key: true
      t.integer :score

      t.timestamps null: false
    end
  end
end
