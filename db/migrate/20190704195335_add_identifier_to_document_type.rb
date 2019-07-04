class AddIdentifierToDocumentType < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE document_type_identifiers AS ENUM ('tco', 'tcai');
      ALTER TABLE document_types ADD identifier document_type_identifiers;
    SQL
  end

  def down
    remove_column :document_types, :identifier
    execute <<-SQL
      DROP TYPE document_type_identifiers;
    SQL
  end
end
