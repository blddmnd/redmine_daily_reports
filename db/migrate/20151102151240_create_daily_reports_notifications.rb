class CreateDailyReportsNotifications < ActiveRecord::Migration
  def change
    create_table :ct_daily_reports_notifications do |t|
      t.integer :project_id
      t.boolean :active
      t.boolean :include_today
      t.text :emails
      t.integer :period
      t.datetime :nextrun_at
      t.text :period_options
    end
  end
end
