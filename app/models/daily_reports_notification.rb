class DailyReportsNotification < ActiveRecord::Base
  unloadable

  PERIOD = { daily: 1, weekly: 2 }

  self.table_name = 'ct_daily_reports_notifications'

  serialize :period_options, Hash
  serialize :emails

  belongs_to :project

  scope :nextrun, -> { where("#{DailyReportsNotification.table_name}.nextrun_at < ?", Time.now) }
  scope :active, -> { where("#{DailyReportsNotification.table_name}.active" => true) }

  after_initialize :set_default_values

  def self.send_all
    active.nextrun.includes(:project).each { |n| n.notify }
  end

  def notify
    reports = []
    if daily?
      date = include_today? ? Date.today : Date.yesterday
      reports = project.all_daily_reports(date)
      DailyReportsMailer.daily(reports, emails, project, date).deliver if reports.present?
    elsif weekly?
      to = include_today? ? Date.today : Date.yesterday
      from = to - 1.week
      reports = project.all_weekly_reports(from, to).group_by(&:author)
      DailyReportsMailer.weekly(reports, emails, project, from, to).deliver if reports.present?
    end
    new_nextrun_at = EasyUtils::DateUtils.calculate_from_period_options(Date.today, period_options)
    update_attribute(:nextrun_at, new_nextrun_at) if nextrun_at != new_nextrun_at
  end

  def split_emails!
    self.emails = emails.split(',').map(&:strip).reject(&:blank?)
    self
  end

  def set_nextrun! date = nil
    self.period_options[:time] = 'defined'
    self.nextrun_at = EasyUtils::DateUtils.calculate_from_period_options(date, self.period_options)
    self
  end

  def daily?
    period == PERIOD[:daily]
  end

  def weekly?
    period == PERIOD[:weekly]
  end

  private

    def set_default_values
      self.period_options ||= {}
      self.emails ||= []
    end

end
