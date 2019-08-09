class AddTsoEnumToDocumentTypeIdentifiers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute "ALTER TYPE document_type_identifiers ADD VALUE 'tso'"
  end

  def down
    execute "ALTER TYPE document_type_identifiers DROP VALUE 'tso'"
  end
end
