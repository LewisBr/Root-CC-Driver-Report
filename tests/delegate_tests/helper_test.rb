require "minitest/autorun"
require_relative '../../lib/Root_CC/helper'

# Tests for various helper methods contained in the helper module.
class DriverTest < Minitest::Test
  def setup
  end
  ###
  # Regex Helper Tests
  ###
  # Tests: #HELPER.stripDriverFromDriverInput
  ###
  def test_driver_strip_nil
    assert_nil HELPER.stripDriverFromDriverInput(nil)
  end

  def test_driver_strip_no_arg
    assert_nil HELPER.stripDriverFromDriverInput
  end
  def test_driver_strip_no_name
    assert_nil HELPER.stripDriverFromDriverInput("Driver ")
  end

  def test_driver_strip_driver_name
    assert_equal HELPER.stripDriverFromDriverInput("Driver Driver"), "Driver"
  end

  def test_driver_strip_trip_name
    assert_equal HELPER.stripDriverFromDriverInput("Driver Trip"), "Trip"
  end

  def test_driver_strip_generic_name
    assert_equal HELPER.stripDriverFromDriverInput("Driver Root"), "Root"
  end

  def test_driver_strip_spaces
    assert_equal HELPER.stripDriverFromDriverInput("Driver Root Insurance"), "Root Insurance"
  end

  # Regex doesn't accept special characters. So will return nil.
  def test_driver_strip_special_character
    assert_nil HELPER.stripDriverFromDriverInput("Driver Root_Insurance&")
  end

  def test_driver_strip_bad_regex_generic
    assert_nil HELPER.stripDriverFromDriverInput("Not An Input")
  end

  def test_driver_strip_bad_regex_trip
    assert_nil HELPER.stripDriverFromDriverInput("Trip Root")
  end

  def test_driver_strip_misordered
    assert_nil HELPER.stripDriverFromDriverInput("Root Driver")
  end

  ###
  # Tests: #HELPER.tripCaptures
  # **Note** Since #HELPER.tripCaptures uses the regex we don't need to test missing components again.
  ###
  def test_trip_captures_nil
    assert_nil HELPER.tripCaptures
  end

  def test_trip_captures_empty_string
    assert_nil HELPER.tripCaptures("")
  end

  def test_trip_captures_bad_input
    assert_nil HELPER.tripCaptures("Not A Trip")
  end

  def test_trip_captures_generic_name
    captures = HELPER.tripCaptures("Trip Root 00:00 8:00 0.12")
    assert_equal captures[0], "Root"
    assert_equal captures[1], "00:00"
    assert_equal captures[2], "8:00"
    assert_equal captures[3], "0.12"
  end

  def test_trip_captures_trip_name
    captures = HELPER.tripCaptures("Trip Trip 00:00 11:11 20.0")
    assert_equal captures[0], "Trip"
    assert_equal captures[1], "00:00"
    assert_equal captures[2], "11:11"
    assert_equal captures[3], "20.0"
  end
end