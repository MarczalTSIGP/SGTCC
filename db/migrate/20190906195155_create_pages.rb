class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :menu_title
      t.text :content
      t.string :url
      t.string :fa_icon
      t.integer :order
      t.boolean :publish, default: false, null: false

      t.timestamps
    end
  end
end
