class EasyRakeTaskDailyReports < EasyRakeTask
  unloadable

  def execute
    started_at = Time.now
    log_info '    Daily reports notifications...'
    DailyReportsNotification.send_all
    log_info "    Daily reports notifications (#{Time.now - started_at}s)"
    true
  end

  def category_caption_key
    :daily_reports
  end

  def registered_in_plugin
    :daily_reports
  end

end
