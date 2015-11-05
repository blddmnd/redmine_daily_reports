 class CreateDailyReportsSettings < ActiveRecord::Migration
  def change
    create_table :ct_daily_reports_settings do |t|
      t.integer :project_id
      t.integer :days_limit
    end
  end
end
