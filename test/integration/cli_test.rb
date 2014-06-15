require 'fileutils'
require_relative File.join('..', 'test_helper')

class TestCLI < Minitest::Test
  include Gemshine::Test

  def test_path
    out, err = capture_subprocess_io do
      gemshine "path #{GEMSHINE_PATH}"
    end

    assert_match /Gathering/, out
  end

  def test_version
    out, err = capture_subprocess_io do
      gemshine 'version'
    end

    assert_match /Gemshine/, out
  end
end