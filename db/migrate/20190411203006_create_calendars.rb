class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.string :year
      t.integer :semester
      t.integer :tcc

      t.timestamps
    end
  end
end
