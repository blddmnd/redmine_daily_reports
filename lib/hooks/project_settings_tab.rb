class ProjectSettingsTab < Redmine::Hook::ViewListener
  def helper_project_settings_tabs context = {}
    if context[:project].module_enabled?(:daily_reports)
      context[:tabs] << {
        name: 'daily_reports',
        action: :manage_daily_reports,
        partial: 'projects/settings/daily_reports',
        label: :daily_reports,
        no_js_link: true
      }
    end
  end
end
