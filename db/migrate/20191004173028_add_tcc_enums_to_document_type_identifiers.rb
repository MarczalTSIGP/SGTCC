class AddTccEnumsToDocumentTypeIdentifiers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute "ALTER TYPE document_type_identifiers ADD VALUE 'adpp'"
    execute "ALTER TYPE document_type_identifiers ADD VALUE 'adpj'"
    execute "ALTER TYPE document_type_identifiers ADD VALUE 'admg'"
  end

  def down
    execute "ALTER TYPE document_type_identifiers DROP VALUE 'adpp'"
    execute "ALTER TYPE document_type_identifiers DROP VALUE 'adpj'"
    execute "ALTER TYPE document_type_identifiers DROP VALUE 'admg'"
  end
end
