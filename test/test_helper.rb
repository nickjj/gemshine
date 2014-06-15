require 'minitest/autorun'

module Gemshine
  module Test

    BINARY_PATH   = File.absolute_path(File.join('..', '..', 'bin', 'gemshine'), __FILE__)
    GEMSHINE_PATH = File.absolute_path(File.join('..', '..'), __FILE__)

    def gemshine(command)
      cmd, project_path = command.split(' ')

      command           = "#{cmd} #{project_path}" if command.include?(' ')

      system "#{BINARY_PATH} #{command}"
    end
  end
end