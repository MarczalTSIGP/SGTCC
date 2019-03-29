class CreateInstitutions < ActiveRecord::Migration[5.2]
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :trade_name
      t.string :cnpj, unique: true
      t.references :external_member, foreign_key: true

      t.timestamps
    end
  end
end
