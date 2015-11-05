class CreateDailyReports < ActiveRecord::Migration
  def change
    create_table :ct_daily_reports do |t|
      t.integer :author_id
      t.integer :project_id
      t.text :text
      t.date :report_date

      t.timestamps null: false
    end
  end
end
