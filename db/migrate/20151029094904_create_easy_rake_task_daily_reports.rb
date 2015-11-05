class CreateEasyRakeTaskDailyReports < ActiveRecord::Migration
  def self.up
    EasyRakeTaskDailyReports.reset_column_information
    t = EasyRakeTaskDailyReports.new(active: true, settings: {}, period: :minutes, interval: 15, next_run_at: Time.now)
    t.builtin = 1
    t.save!
  end

  def self.down
    EasyRakeTaskDailyReports.destroy_all
  end
end
