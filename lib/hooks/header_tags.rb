class HeaderTagsHook < Redmine::Hook::ViewListener
  def view_layouts_base_html_head context = {}
    if context[:controller] && context[:controller].is_a?(DailyReportsController)
      tags = ''
      tags << javascript_include_tag('jquery.truncator', plugin: 'redmine_daily_reports')
      tags << javascript_include_tag('daily_reports', plugin: 'redmine_daily_reports')
      tags << stylesheet_link_tag('daily_reports', plugin: 'redmine_daily_reports', media: 'screen')
      tags.html_safe
    end
  end
end
