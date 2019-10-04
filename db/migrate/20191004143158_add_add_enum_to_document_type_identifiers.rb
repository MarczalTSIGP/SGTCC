class AddAddEnumToDocumentTypeIdentifiers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute "ALTER TYPE document_type_identifiers ADD VALUE 'add'"
  end

  def down
    execute "ALTER TYPE document_type_identifiers DROP VALUE 'add'"
  end
end
