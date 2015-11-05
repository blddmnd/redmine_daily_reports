require 'mailer'

class DailyReportsMailer < Mailer
  unloadable
  include Redmine::I18n
  layout 'daily_reports_mailer'

  def daily reports, emails, project, date
    @project = project
    @reports = reports

    mail to: emails, subject: l(:daily_reports_daily_subject, date: date)
  end

  def weekly reports, emails, project, from, to
    @project = project
    @reports = reports

    mail to: emails, subject: l(:daily_reports_weekly_subject, from: from, to: to)
  end

end
