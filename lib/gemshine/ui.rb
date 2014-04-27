require 'terminal-table'

module Gemshine
  module UI
    MSG_PATH_STATS = 'projects were detected, working...'
    MSG_MISSING_GEMFILE = 'A Gemfile could not be found for:'
    MSG_GATHER_OUTDATED = 'Gathering outdated top level gems for:'
    MSG_UP_TO_DATE = 'Every gem is up to date for this project.'
    MSG_BUNDLE_ERROR = 'Bundler reported an issue with this project, here it is:'
    MSG_BUNDLE_OUTDATED = 'Outdated gems included in the bundle'
    MSG_BUNDLE_UP_TO_DATE = 'Your bundle is up to date'

    def run_bundle_outdated
      pwd = Dir.pwd

      run "cd #{@project_dir} && bundle outdated && cd #{pwd}", capture: true
    end

    def gem_table(rows)
      if rows.empty?
        log_up_to_date
        return
      end

      rows.sort!

      table = Terminal::Table.new title: @project_name, headings: %w(Gem Defined Installed Latest),
                                  style: { width: 80 } do |t|
        t.rows = rows
        t.add_separator
        t.add_row ["#{rows.size} outdated gems", '', '', '']
      end

      puts
      puts table
    end

    def log_path_stats
      puts
      say_status 'stats', "#{@projects} #{MSG_PATH_STATS}", :yellow
    end

    def log_project
      log_status 'info', MSG_GATHER_OUTDATED, :blue
      log_project_name :cyan
    end

    def log_up_to_date
      puts
      say_status 'nice', MSG_UP_TO_DATE, :magenta
    end

    def log_missing
      log_status 'skip', MSG_MISSING_GEMFILE, :red
      log_project_name :yellow
    end

    def log_bundle_message(message)
      log_status 'warning', MSG_BUNDLE_ERROR, :red
      say_status 'message', message, :yellow
      puts
    end

    private

      def log_status(type, message, color)
        puts
        say_status type, set_color(message, :bold), color
      end

      def log_project_name(color)
        say_status 'project', @project_name, color
        puts
      end
  end
end