class DailyReport < ActiveRecord::Base
  unloadable

  self.table_name = 'ct_daily_reports'

  belongs_to :project
  belongs_to :author, class_name: 'User'

  validates_presence_of :text, :report_date, :author_id
  validates_uniqueness_of :author_id, scope: [:report_date, :project_id]
  validate :report_date_range

  def editable? project, user = User.current
    user.allowed_to?(:manage_daily_reports, project) || (author == user && (project.daily_reports_setting.blank? || report_date > project.daily_reports_setting.days_limit.days.ago))
  end

  def min_date
    if !User.current.allowed_to?(:manage_daily_reports, project) && project.daily_reports_setting.present?
      Date.today - project.daily_reports_setting.days_limit.days
    else
      Date.new(0000,1,1)
    end
  end

  private

    def report_date_range
      errors.add(:base, l(:daily_reports_date_error)) if report_date > Date.today || report_date < min_date
    end

end
