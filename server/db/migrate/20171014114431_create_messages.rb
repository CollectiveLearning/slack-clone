class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :type, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :channel, foreign_key: true, null: false

      t.timestamps
    end
  end
end
