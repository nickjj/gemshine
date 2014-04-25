require 'terminal-table'
require 'gemshine/version'

module Gemshine
  class Command
    include Thor::Base
    include Thor::Shell
    include Thor::Actions

    def initialize(app_name = '', options = {})
      @app_name = app_name
      @options = options

      self.destination_root = Dir.pwd
      @behavior = :invoke
    end

    def path
      rows = []
      gems_regex = ''
      gems_total = 0

      ruby_project_directories.each do |project_dir|
        gemfile_path = File.join(project_dir, 'Gemfile')

        if File.exists?(gemfile_path)
          File.open(gemfile_path, 'r').each_line do |line|
            clean_gem_line = line.strip

            if clean_gem_line.start_with?('gem ')
              gem_info = parse_gemfile_line(clean_gem_line)

              rows << gem_info

              gems_regex << "^#{gem_info[0]}$|"

              gems_total += 1
            end
          end

          rows.sort!

          log_project File.basename(project_dir)

          if gems_regex.empty?
            puts "There are no gems defined in this project's Gemfile"
          else
            rubygems_data = run("gem list '#{gems_regex[0...-1]}' --remote --all", capture: true)

            parse_rubygems_response rubygems_data, rows

            table = Terminal::Table.new title: File.basename(project_dir), headings: %w(Gem Gemfile Latest) do |t|
              t.rows = rows
              t.add_separator
              t.add_row ["#{gems_total} total gems", '', '']
            end

            puts
            puts table
          end

          rows = []
          gems_regex = ''
          gems_total = 0
        end
      end
    end

    def version
      puts "Gemshine version #{VERSION}"
    end

    private

      def parse_gemfile_line(gem_line)
        line_parts = gem_line.split(',')
        gem_name = line_parts[0][5...-1]

        if line_parts[1]
          might_be_version = line_parts[1].strip
        else
          might_be_version = ''
        end

        if might_be_version && (might_be_version.start_with?('"') || might_be_version.start_with?("'"))
          gem_version = line_parts[1][2...-1]
        else
          gem_version = '--------->'
        end

        [gem_name, gem_version, 'N/A']
      end

      def parse_rubygems_response(rubygems_data, gemlist_rows)
        rubygems_parts = rubygems_data.split("\n")

        rubygems_parts.to_enum.each_with_index do |gem_data, i|
          gem_data_parts = gem_data.split

          might_be_latest_gem_version = gem_data_parts[1][1..-1].strip

          if might_be_latest_gem_version.end_with?(',')
            latest_gem_version = might_be_latest_gem_version[0...-1]
          else
            latest_gem_version = might_be_latest_gem_version
          end

          gemlist_rows[i][2] = latest_gem_version
        end
      end

      def ruby_project_directories
        rails_gemfiles = run("find #{@app_name} -type f -name Gemfile", capture: true)
        gemfile_paths = rails_gemfiles.split("\n")

        gemfile_paths.map { |gemfile| File.dirname(gemfile) }
      end

      def log_project(project_name)
        puts
        say_status  'info', "\e[1mGathering the latest gem versions for:\e[0m", :yellow
        say_status  'project', project_name, :cyan
        puts
      end
  end
end