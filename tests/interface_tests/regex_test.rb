require "minitest/autorun"
require_relative '../../lib/Root_CC/helper'

class RegexTest < Minitest::Test

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end
  ###
  # DRIVER REGEX TESTS
  ###
  # Tests: #HELPER::REGEX_DRIVER
  def test_driver_empty_string
    assert_nil HELPER::REGEX_DRIVER=~"", 0
  end

  def test_driver_nil
    assert_nil HELPER::REGEX_DRIVER=~nil, 0
  end

  def test_bad_not_driver
    assert_nil HELPER::REGEX_DRIVER=~"Not A Driver"
  end

  def test_bad_no_driver
    assert_nil HELPER::REGEX_DRIVER=~"Driver "
  end

  def test_bad_start_of_driver
    assert_nil HELPER::REGEX_DRIVER=~"~Driver Root"
  end

  def test_generic_driver
    assert_equal HELPER::REGEX_DRIVER=~"Driver Root", 0
  end

  def test_generic_driver_case_insensitive
    assert_equal HELPER::REGEX_DRIVER=~"dRiVeR Root", 0
  end

  def test_generic_driver_with_spaces
    assert_equal HELPER::REGEX_DRIVER=~"Driver Root Insurance", 0
  end

  def test_generic_driver_special_characters
    assert_nil HELPER::REGEX_DRIVER=~"Driver &&war"
  end

  def test_generic_driver_with_numbers
    assert_nil HELPER::REGEX_DRIVER=~"Not A Driver"
  end

  def test_driver_numbers
    assert_nil HELPER::REGEX_DRIVER=~"Driver 100", 0
  end

  ###
  # TRIP REGEX TESTS
  # Tests: #HELPER::REGEX_TRIP
  ###
  def test_trip_empty_string
    assert_nil HELPER::REGEX_TRIP=~""
  end

  def test_trip_nil
    assert_nil HELPER::REGEX_TRIP=~nil
  end

  def test_trip_parts_doc_brown
    assert_nil HELPER::REGEX_TRIP=~"Trip Emmett 19:85 20:15 88"
  end

  def test_trip_generic_good
    assert_equal HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 55", 0
  end

  def test_trip_generic_good_case_insensitive
    assert_equal HELPER::REGEX_TRIP=~"tRiP rOoT 00:00 11:00 55", 0
  end

  def test_trip_generic_zero_velocity
    assert_equal HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 0", 0
  end

  def test_trip_generic_negative_velocity
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 -55", 0
  end

  def test_trip_generic_decimal_velocity
    assert_equal HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 .10", 0

  end

  def test_trip_generic_decimal_only
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 ."
  end

  def test_trip_generic_digit_decimal_only
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 00:00 11:00 1."
  end

  def test_trip_single_digit_hours
    assert_equal HELPER::REGEX_TRIP=~"Trip Root 0:00 1:00 55", 0
  end

  def test_trip_no_hours
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 55"
  end

  def test_trip_one_time_block
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 00:00 55"
  end

  def test_trip_no_name
    assert_nil HELPER::REGEX_TRIP=~"Trip 0:00 1:00 55"
  end

  def test_trip_leading_space
    assert_nil HELPER::REGEX_TRIP=~" Trip Root 0:00 1:00 55"
  end

  def test_trip_trailing_space
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 0:00 1:00 55 "
  end

  def test_trip_parts_mismatched_1
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 0:00 55 1:00"
  end

  def test_trip_parts_mismatched_2
    assert_nil HELPER::REGEX_TRIP=~"Root Trip 0:00 1:00 55"
  end

  def test_trip_parts_mismatched_3
    assert_nil HELPER::REGEX_TRIP=~"0:00 1:00 Trip Root 55"
  end

  def test_trip_parts_mismatched_4
    assert_nil HELPER::REGEX_TRIP=~"55 0:00 1:00 Trip Root"
  end

  def test_trip_parts_mismatched_5
    assert_nil HELPER::REGEX_TRIP=~"Trip Root 0:00 55 1:00"
  end

  ###
  # FLOAT REGEX TESTS
  # Tests: #HELPER::REGEX_CONFIG_FLOAT
  ###
  def test_float_empty_string
    assert_nil HELPER::REGEX_CONFIG_FLOAT=~"", 0
  end

  def test_float_nil
    assert_nil HELPER::REGEX_CONFIG_FLOAT=~nil, 0
  end

  def test_bad_not_float
    assert_nil HELPER::REGEX_CONFIG_FLOAT=~"Not A Float"
  end

  def test_bad_start_of_float
    assert_nil HELPER::REGEX_CONFIG_FLOAT=~"~1.0"
  end

  def test_generic_float
    assert_equal HELPER::REGEX_CONFIG_FLOAT=~"0.0", 0
  end

  def test_generic_float_no_integer
    assert_equal HELPER::REGEX_CONFIG_FLOAT=~".0", 0
  end

  def test_generic_float_negative_float
    assert_nil HELPER::REGEX_CONFIG_FLOAT=~"-1.0"
  end
end