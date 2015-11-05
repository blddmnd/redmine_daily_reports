require 'redmine'

require_dependency 'patches/project'

require_dependency 'hooks/header_tags'
require_dependency 'hooks/project_settings_tab'

require_dependency 'mailers/daily_reports_mailer'

Redmine::Plugin.register :redmine_daily_reports do
  name 'Redmine Daily Reports plugin'
  author 'Alexander Morozov'
  description 'Team Projects Daily Reports'
  version '0.1.1'
  url 'https://github.com/blddmnd/redmine_daily_reports'
  author_url 'http://customertimes.com/'

  permission :manage_daily_reports_project_setting, { projects: :settings, daily_reports: :save_settings }, require: :member
  project_module :daily_reports do
    permission :view_daily_reports, { daily_reports: [:index, :new, :edit, :create, :update, :destroy, :reload_form] }, require: :member
    permission :manage_daily_reports, {}, require: :member
  end

  menu :project_menu, :daily_reports,
       { controller: :daily_reports, action: :index },
       caption: :daily_reports,
       param: :project_id
end

Rails.configuration.to_prepare do

  unless Project.included_modules.include?(DailyReports::ProjectPatch)
    Project.send :include, DailyReports::ProjectPatch
  end

end
