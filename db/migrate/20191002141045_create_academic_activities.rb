class CreateAcademicActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :academic_activities do |t|
      t.references :academic, foreign_key: true
      t.references :activity, foreign_key: true
      t.string :pdf
      t.string :complementary_files, null: true
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
