require 'thor'
require 'gemshine/command'

module Gemshine
  class CLI < Thor
    desc 'path PROJECT_PATH', ''
    long_desc <<-D
      `gemshine path myapp` will recursively search through the myapp path and report the current vs latest gem versions for all ruby projects.
    D
    def path(app_name)
      Command.new(app_name, options).path
    end

    desc 'version', ''
    long_desc <<-D
      `gemshine --version` will print the current version.
    D
    def version
      Command.new.version
    end
    map %w(-v --version) => :version
  end
end