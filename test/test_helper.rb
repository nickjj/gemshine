require 'minitest/autorun'

module Gemshine
  module Test

    BINARY_PATH = File.absolute_path(File.join('..', '..', 'bin', 'gemshine'),__FILE__)
    TEST_PATH = File.join('tmp', 'gemshine')

    def gemshine(command)
      cmd, project_path = command.split(' ')
      command = "#{cmd} #{File.join(TEST_PATH, project_path)}" if command.include?(' ')

      system "#{BINARY_PATH} #{command}"
    end
  end
end