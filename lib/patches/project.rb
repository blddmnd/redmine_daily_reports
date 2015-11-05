module DailyReports
  module ProjectPatch

    def self.included(base) # :nodoc:
      unloadable
      base.send(:include, InstanceMethods)
      base.class_eval do
        has_many :daily_reports, dependent: :destroy
        has_one  :daily_reports_setting, dependent: :destroy
        has_many :daily_reports_notifications, dependent: :destroy

        has_one  :daily_reports_daily_notify, -> { where("#{DailyReportsNotification.table_name}.period = ?", DailyReportsNotification::PERIOD[:daily])
          }, class_name: 'DailyReportsNotification'
        has_one  :daily_reports_weekly_notify, -> { where("#{DailyReportsNotification.table_name}.period = ?", DailyReportsNotification::PERIOD[:weekly])
          }, class_name: 'DailyReportsNotification'
      end
    end

    module InstanceMethods

      def get_daily_reports_setting
        daily_reports_setting || build_daily_reports_setting
      end

      def get_daily_reports_notifications
        daily = daily_reports_daily_notify || build_daily_reports_daily_notify(period: DailyReportsNotification::PERIOD[:daily])
        weekly = daily_reports_weekly_notify || build_daily_reports_weekly_notify(period: DailyReportsNotification::PERIOD[:weekly])
        [daily, weekly]
      end

      def all_daily_reports date
        daily_reports.where(report_date: date).includes(:author)
      end

      def all_weekly_reports from, to
        daily_reports.where(report_date: from..to).includes(:author).order(:report_date)
      end

      def can_create_daily_report? date, user = User.current
        user.allowed_to?(:manage_daily_reports, self) || daily_reports_setting.blank? || date > daily_reports_setting.days_limit.days.ago
      end

    end

  end
end
