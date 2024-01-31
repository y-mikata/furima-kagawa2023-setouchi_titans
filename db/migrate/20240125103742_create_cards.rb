class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string  :card_id,     null: false
      t.string :last4,       null: false
      t.string :exp_month,   null: false
      t.string :exp_year,    null: false
      t.boolean :is_default,  null: false

      t.references :user,       foreign_key: true

      t.timestamps
    end
  end
end
