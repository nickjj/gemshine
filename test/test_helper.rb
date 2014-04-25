require 'minitest/autorun'
require 'securerandom'

module Gemshine
  module Test
    BINARY_PATH = File.absolute_path('../../bin/gemshine',__FILE__)
    TEST_PATH = '/tmp/gemshine'

    def gemshine(command)
      cmd, project_path = command.split(' ')
      command = "#{cmd} #{TEST_PATH}/#{project_path}" if command.include?(' ')

      system "#{BINARY_PATH} #{command}"
    end
  end
end