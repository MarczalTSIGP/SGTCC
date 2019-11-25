class AddAdditionalInstructionsToAcademicActivities < ActiveRecord::Migration[5.2]
  change_table :academic_activities, bulk: true do |t|
    t.text :additional_instructions, null: true
  end
end
