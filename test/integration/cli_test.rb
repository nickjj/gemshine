require_relative '../test_helper'

class TestCLI < Minitest::Unit::TestCase
  include Gemshine::Test

  def test_path
    out, err = capture_subprocess_io do
      gemshine 'path Gemfile'
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