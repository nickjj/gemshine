require 'terminal-table'
require 'gemshine/version'

module Gemshine
  class Command
    include Thor::Base
    include Thor::Shell
    include Thor::Actions

    MSG_MISSING_GEMFILE = 'A Gemfile could not be found for:'
    MSG_GATHER_OUTDATED = 'Gathering outdated top level gems for:'
    MSG_UP_TO_DATE = 'Every top level gem is up to date for this project.'

    def initialize(app_name = '', options = {})
      @app_name = app_name
      @options = options

      self.destination_root = Dir.pwd
      @behavior = :invoke
    end

    def path
      ruby_project_directories.each do |project_dir|
        gemfile_path = File.join(project_dir, 'Gemfile')
        project_name = File.basename(project_dir)

        log_project File.basename(project_dir)

        unless File.exists?(gemfile_path)
          log_missing project_name
          next
        end

        gem_table build_gem_list(bundle_outdated(project_dir), project_dir), project_name
      end
    end

    def version
      puts "Gemshine version #{VERSION}"
    end

    private

      def ruby_project_directories
        gemfiles = run("find #{@app_name} -type f -name Gemfile", capture: true)
        gemfile_paths = gemfiles.split("\n")

        gemfile_paths.map { |gemfile| File.dirname(gemfile) }
      end

      def bundle_outdated(path)
        run "cd #{path} && bundle outdated && cd -", capture: true
      end

      def build_gem_list(data, project_dir)
        plucked_gems(data, project_dir).map! { |gem| parse_gem_data(gem) }
      end

      def plucked_gems(bundle_data, project_dir)
        lines = bundle_data.split("\n")

        gemfile_path = File.join(project_dir, 'Gemfile')
        gemspec_path = Dir.glob("#{project_dir}/*.gemspec").first
        gemfile_contents = IO.read(gemfile_path)

        gemspec_path ? gemspec_contents = IO.read(gemspec_path) : gemspec_contents = ''

        lines.keep_if do |line|
          line.strip!
          line.start_with?('*')
        end

        lines.keep_if do |line|
          parts = line.split

          parts[0] == '*' ? is_gem_line = true : is_gem_line = false

          is_gem_line ? name = parts[1][0..-1] : name = ''

          expression = /\b#{name}\b/

          is_gem_line && gemfile_contents.match(expression) || gemspec_contents.match(expression)
        end

        lines.map! { |line| line[2..-1] }
      end

      def parse_gem_data(line)
        parts = line.split

        name = parts[0]
        ver_installed = parts[3][0...-1]
        ver_latest = parts[1][1..-1]
        ver_specific = parts[4]
        ver_defined = ''
        ver_operator = ''
        ver_locked = ''

        if ver_specific
          ver_operator = parts[6][1..-1]
          ver_locked = parts[7][0...-1]
          ver_defined = "#{ver_operator} #{ver_locked}"
        end

        [name, ver_defined, ver_installed, ver_latest]
      end

      def gem_table(rows, title)
        if rows.size == 0
          log_up_to_date
          return
        end

        rows.sort!

        table = Terminal::Table.new title: title, headings: %w(Gem Defined Installed Latest), style: {width: 80} do |t|
          t.rows = rows
          t.add_separator
          t.add_row ["#{rows.size} outdated gems", '', '', '']
        end

        puts
        puts table
      end

      def log_project(project_name)
        puts
        say_status 'info', "\e[1m#{MSG_GATHER_OUTDATED}\e[0m", :yellow
        say_status 'project', project_name, :cyan
        puts
      end

      def log_up_to_date
        puts
        say_status 'nice', "#{MSG_UP_TO_DATE}", :magenta
      end

      def log_missing(project_name)
        puts
        say_status 'skip', "\e[1m#{MSG_MISSING_GEMFILE}\e[0m", :red
        say_status 'project', project_name, :yellow
        puts
      end
  end
end