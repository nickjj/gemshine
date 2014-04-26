require 'fileutils'
require_relative  File.join('..', 'test_helper')

class TestCLI < Minitest::Unit::TestCase
  include Gemshine::Test

  def test_path
    create_dummy_gemfile

    out, err = capture_subprocess_io do
      gemshine 'path Gemfile'
    end

    FileUtils.rm_rf TEST_PATH

    assert_match '', out
  end

  def test_version
    out, err = capture_subprocess_io do
      gemshine 'version'
    end

    assert_match /Gemshine/, out
  end

  private

    def create_dummy_gemfile
      gems = []
      gems << 'gem "rails", "~> 4.0.0"'
      gems << '       gem "sidekiq", "~> 2.17.4"'
      gems << 'gem "whenever", require: false'
      gems << 'gemwhenever",,,,d,,e'
      gems << 'gem "sdoc", "~> 0.4.0", require: false'
      gems << ' '

      FileUtils.mkpath TEST_PATH

      File.open(TEST_GEMFILE, 'w+') do |f|
        gems.each { |element| f.puts(element) }
      end
    end
end