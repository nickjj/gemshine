require 'gemshine/ui'
require 'gemshine/version'

module Gemshine
  class Command
    include Thor::Base
    include Thor::Shell
    include Thor::Actions

    include UI

    attr_accessor :project_dir, :project_name, :projects, :gemfile_path, :bundle_outdated_output

    def initialize(root_path = '', options = {})
      @root_path = root_path
      @options = options

      self.destination_root = Dir.pwd
      @behavior = :invoke
    end

    def path
      ruby_project_directories.each do |project_dir|
        @project_dir = project_dir
        @project_name = File.basename(@project_dir)
        @gemfile_path = File.join(@project_dir, 'Gemfile')

        log_project

        unless File.exists?(@gemfile_path)
          log_missing
          next
        end

        @bundle_outdated_output = run_bundle_outdated

        if @bundle_outdated_output.match(/\b#{MSG_BUNDLE_UP_TO_DATE}\b/)
          log_up_to_date
          next
        end

        unless @bundle_outdated_output.match(/\b#{MSG_BUNDLE_OUTDATED}\b/)
          log_bundle_message @bundle_outdated_output
          next
        end

        gem_table valid_gem_list
      end
    end

    def version
      puts "Gemshine version #{VERSION}"
    end

    private

      def ruby_project_directories
        gemfile_paths = Dir.glob(File.join(@root_path, '**', 'Gemfile'))

        @projects = gemfile_paths.size
        log_path_stats

        gemfile_paths.map { |gemfile| File.dirname(gemfile) }
      end

      def valid_gem_list
        plucked_gems.map! { |line| parse_gem_from(line) }
      end

      def plucked_gems
        data = @bundle_outdated_output.split("\n")

        parse_out_gem_lines data
        filter_top_level_gems data

        data.map! { |line| line[2..-1] }
      end

      def parse_out_gem_lines(data)
        data.keep_if do |line|
          line.strip!
          line.start_with?('*')
        end
      end

      def filter_top_level_gems(data)
        gemspec_path = Dir.glob(File.join(@project_dir, '*.gemspec')).first
        gemfile_contents = IO.read(@gemfile_path)

        gemspec_path ? gemspec_contents = IO.read(gemspec_path) : gemspec_contents = ''

        data.keep_if do |line|
          parts = line.split

          parts.first == '*' ? is_gem_line = true : is_gem_line = false

          is_gem_line ? name = parts[1][0..-1] : name = ''

          expression = /\b#{name}\b/

          is_gem_line && gemfile_contents.match(expression) || gemspec_contents.match(expression)
        end
      end

      def parse_gem_from(line)
        parts = line.split

        name = parts.first
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

        [
          name,
          ver_defined,
          set_color(ver_installed, detect_outdated_color(ver_installed, ver_latest)),
          set_color(ver_latest, :green)
        ]
      end
  end
end