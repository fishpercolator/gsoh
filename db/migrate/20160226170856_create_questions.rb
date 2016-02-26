class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :type
      t.string :text
      t.string :ftype
      t.boolean :ask_subtype

      t.timestamps null: false
    end
  end
end
