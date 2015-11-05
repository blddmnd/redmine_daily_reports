Redmine Daily Reports Plugin
====================

## About:

Daily Report Plugin is created to simplify a team and project coordination. There is ability for automatic email sending to specified emails (customer, project manager, product owner etc.) which set in the settings. Plugin is set up to separate projects into Project panel. So it is easy to check reports for different projects separatly. Each project team member will create own daily report which will be collected in project daily report and sent to specified emails. Daily Reports can be created/edited for previous days but it can be limited by admin. Automatic sending (frequency, time etc) adjusts by admin.

## How to Install:

To install the Daily Reports, execute the following commands from the plugin directory of your redmine directory:

    git clone git@github.com:blddmnd/redmine_daily_reports.git
    RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redmine_daily_reports

Note: you should specify correct Rails environment.

After the plugin is installed and the db migration completed, you will
need to restart redmine for the plugin to be available.

## How to Use:

* Enable the plugin from the settings of the project.

* Assigning permission to users for viewing and managing daily reports.

## How to Uninstall:

    RAILS_ENV=production bundle exec rake redmine:plugins:migrate NAME=redmine_daily_reports VERSION=0
* Remove the redmine_daily_reports directory from the plugin directory and then restart redmine.
