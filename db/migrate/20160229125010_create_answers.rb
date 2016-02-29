class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :type
      t.references :user, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.integer :answer
      t.string :subtype

      t.timestamps null: false
    end
  end
end
