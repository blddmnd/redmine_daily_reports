class DailyReportsController < ApplicationController
  unloadable

  before_action :find_project_by_project_id, :authorize
  before_action :parse_date, only: [:index, :new, :reload_form]
  before_action :find_or_initialize_daily_report, only: [:new, :reload_form]
  before_action :set_daily_report, only: [:edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]
  before_action :get_available_users, only: [:new, :reload_form, :edit]

  def index
    @daily_reports = @project.all_daily_reports(@date).to_a
    @daily_reports.each_with_index do |r, i|
      @daily_reports.unshift(@daily_reports.delete_at(i)) and break if r.author == User.current
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
  end

  def edit
    @date = @daily_report.report_date
  end

  def create
    @daily_report = DailyReport.new(daily_report_params)
    @daily_report.project = @project
    check_access

    respond_to do |format|
      if @daily_report.save
        format.html { redirect_to project_daily_reports_url(date: @daily_report.report_date), notice: 'Daily report was successfully created.' }
      else
        get_available_users
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @daily_report.update(daily_report_params)
        format.html { redirect_to project_daily_reports_url(date: @daily_report.report_date), notice: 'Daily report was successfully updated.' }
      else
        get_available_users
        format.html { render :edit }
      end
    end
  end

  def destroy
    @daily_report.destroy
    respond_to do |format|
      format.html { redirect_to project_daily_reports_url(date: @daily_report.report_date), notice: 'Daily report was successfully destroyed.' }
      format.json { head :no_content }
      format.js   { render layout: false }
    end
  end

  def reload_form
  end

  def save_settings
    setting = @project.get_daily_reports_setting
    daily, weekly = @project.get_daily_reports_notifications

    setting.assign_attributes(settings_params)

    daily.assign_attributes(daily_params)
    daily.split_emails!.set_nextrun!

    weekly.assign_attributes(weekly_params)
    weekly.split_emails!.set_nextrun!

    [setting, daily, weekly].each { |e| e.save }

    redirect_to settings_project_path(@project, :daily_reports)
  end

  private

    def check_access
      if !User.current.allowed_to?(:manage_daily_reports, @project) && @daily_report.author_id != User.current.id
        deny_access
        return
      end
    end

    def parse_date
      @date = Date.parse(params[:date])
    rescue
      @date = Date.today
    end

    def get_available_users
      @users = @project.users
    end

    def find_or_initialize_daily_report
      @daily_report = DailyReport.where(
        project: @project,
        author_id: params[:author_id] || User.current.id,
        report_date: @date
      ).first_or_initialize
    end

    def set_daily_report
      @daily_report = @project.daily_reports.find(params[:id])
    end

    def daily_report_params
      params.require(:daily_report).permit(:author_id, :text, :report_date)
    end

    def settings_params
      params.require(:setting).permit(:days_limit)
    end

    def daily_params
      params.require(:daily).permit(:active, :include_today, :emails, period_options: [:period, :hours])
    end

    def weekly_params
      params.require(:weekly).permit(:active, :include_today, :emails, period_options: [:period, :hours, days_in_week: []])
    end

end
