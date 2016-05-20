class AddNeedsRegenerationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :needs_regeneration, :boolean
  end
end
