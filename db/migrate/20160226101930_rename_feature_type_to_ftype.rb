class RenameFeatureTypeToFtype < ActiveRecord::Migration
  def change
    rename_column :features, :type, :ftype
  end
end
