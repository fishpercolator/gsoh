class CreateAreasFeatures < ActiveRecord::Migration
  def change
    create_table :areas_features do |t|
      t.references :area, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true
    end
  end
end
