require "minitest/autorun"
require_relative '../../lib/Root_CC/driver'
require_relative '../../lib/Root_CC/trip'
require_relative '../../lib/Root_CC/helper'

# Tests for the Driver class and it's utilized class methods.
class DriverTest < Minitest::Test
  def setup
  end

  ###
  # Constructor Tests
  ###
  def test_constructor_generic
    obj = Driver.new('Root',true,[])

    assert_equal obj.name, "Root"
    assert obj.registered
    assert_equal obj.trips, []
  end

  def test_constructor_default_properties
    obj = Driver.new('Root')

    assert_equal obj.name, "Root"
    assert !obj.registered
    assert_equal obj.trips, []
  end

  ###
  # Method Tests
  ###
  # Tests: #Driver.selectValidTrips && #Driver.validTrip (By abstraction)
  ###
  def test_driver_valid_trips_nil
    obj = Driver.new("Root", true,nil)
    assert_nil obj.selectValidTrips
  end

  def test_driver_valid_trips_empty
    obj = Driver.new("Root", true,[])
    assert_equal obj.selectValidTrips, []
  end

  def test_driver_valid_trips_not_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",4)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.selectValidTrips.size, 0
  end

  def test_driver_valid_trips_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.selectValidTrips.size, 1
  end

  def test_driver_valid_trips_mixed_bag
    trip1 = Trip.new("08:00","10:00",4)
    trip2 = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.selectValidTrips.size, 1
  end

  # Nonstandard tests for valid trips where min/max velocities are overloaded.  Screws with other results when run as suite.
  def disabled_test_driver_valid_trips_not_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50
    trip = Trip.new("00:00","10:00",49)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.selectValidTrips.size, 0
  end

  def disabled_test_driver_valid_trips_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.selectValidTrips.size, 1
  end

  def disabled_test_driver_valid_trips_mixed_bag_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip1 = Trip.new("08:00","10:00",51)
    trip2 = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.selectValidTrips.size, 1
  end

  ###
  # Tests: #Driver.averageTripVelocity
  ###
  def test_driver_average_trip_velocity_nil
    obj = Driver.new("Root",true,nil)
    assert_equal obj.averageTripVelocity, 0
  end

  def test_driver_average_trip_velocity_empty
    obj = Driver.new("Root",true,[])
    assert_equal obj.averageTripVelocity, 0
  end

  def test_driver_average_trip_velocity_not_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",4)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.averageTripVelocity, 0
  end

  def test_driver_average_trip_velocity_multiple_not_valid
    # Default is 5 -> 100
    trip1 = Trip.new("00:00","10:00",4)
    trip2 = Trip.new("00:00","10:00",101)
    obj = Driver.new("Root", true,[trip1,trip2])
    assert_equal obj.averageTripVelocity, 0
  end

  def test_driver_average_trip_velocity_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.averageTripVelocity, 25
  end

  def test_driver_average_trip_velocity_multiple_valid
    # Default is 5 -> 100
    trip1 = Trip.new("00:00","10:00",20)
    trip2 = Trip.new("00:00","10:00",40)
    obj = Driver.new("Root", true,[trip1,trip2])
    assert_equal obj.averageTripVelocity, 30
  end

  def test_driver_average_trip_velocity_mixed_bag
    trip1 = Trip.new("08:00","10:00",4)
    trip2 = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.averageTripVelocity, 25
  end

  # Nonstandard tests for valid trips where min/max velocities are overloaded.  Screws with other results when run as suite.
  def disabled_test_average_trip_velocity_not_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50
    trip = Trip.new("00:00","10:00",49)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.averageTripVelocity, 0
  end

  def disabled_test_average_trip_velocity_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.averageTripVelocity, 50
  end

  def disabled_test_average_trip_velocity_mixed_bag_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip1 = Trip.new("08:00","10:00",51)
    trip2 = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.averageTripVelocity, 50
  end

  ###
  # Tests: #Driver.totalLengthOfTrips
  ###
  def test_driver_average_trip_length_nil
    obj = Driver.new("Root",true,nil)
    assert_equal obj.totalLengthOfTrips, 0
  end

  def test_driver_average_trip_length_empty
    obj = Driver.new("Root",true,[])
    assert_equal obj.totalLengthOfTrips, 0
  end

  def test_driver_average_trip_length_not_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",4)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.totalLengthOfTrips, 0
  end

  def test_driver_average_trip_length_multiple_not_valid
    # Default is 5 -> 100
    trip1 = Trip.new("00:00","10:00",4)
    trip2 = Trip.new("00:00","10:00",101)
    obj = Driver.new("Root", true,[trip1,trip2])
    assert_equal obj.totalLengthOfTrips, 0
  end

  def test_driver_average_trip_length_valid
    # Default is 5 -> 100
    trip = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.totalLengthOfTrips, (25*10)
  end

  def test_driver_average_trip_length_multiple_valid
    # Default is 5 -> 100
    trip1 = Trip.new("00:00","10:00",20)
    trip2 = Trip.new("00:00","10:00",40)
    obj = Driver.new("Root", true,[trip1,trip2])
    assert_equal obj.totalLengthOfTrips, ((20*10) + (40*10))
  end

  def test_driver_average_trip_length_mixed_bag
    trip1 = Trip.new("08:00","10:00",4)
    trip2 = Trip.new("00:00","10:00",25)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.totalLengthOfTrips, (25*10)
  end
  # Nonstandard tests for valid trips where min/max velocities are overloaded.  Screws with other results when run as suite.
  def disabled_test_driver_average_trip_length_not_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50
    trip = Trip.new("00:00","10:00",49)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.totalLengthOfTrips, 0
  end

  def disabled_test_driver_average_trip_length_valid_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip])
    assert_equal obj.totalLengthOfTrips, (50*10)
  end

  def disabled_test_driver_average_trip_length_mixed_bag_nondefault
    HELPER.config_min_velocity = 50
    HELPER.config_max_velocity = 50

    trip1 = Trip.new("08:00","10:00",51)
    trip2 = Trip.new("00:00","10:00",50)
    obj = Driver.new("Root", true,[trip1, trip2])
    assert_equal obj.totalLengthOfTrips, (50*10)
  end
end