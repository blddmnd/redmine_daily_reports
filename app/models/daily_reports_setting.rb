class DailyReportsSetting < ActiveRecord::Base
  unloadable

  self.table_name = 'ct_daily_reports_settings'

  belongs_to :project

  after_initialize { self.days_limit ||= 7 }

end
