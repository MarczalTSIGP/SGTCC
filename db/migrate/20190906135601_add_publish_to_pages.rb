class AddPublishToPages < ActiveRecord::Migration[5.2]
  change_table :pages, bulk: true do |t|
    t.boolean :publish, default: false
  end
end
