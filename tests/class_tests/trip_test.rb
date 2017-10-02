require "minitest/autorun"
require_relative '../../lib/Root_CC/trip'

# Tests for the Trip class and it's utilized class methods.
class DriverTest < Minitest::Test
  def setup
  end
  ###
  # Constructor Tests
  # Note-- constructor cases on times exceeding possible times is handled in the regex test cases.  As a result don't need to test them here
  ###
  def test_constructor_generic
    obj = Trip.new('00:00','24:00',55)

    assert_equal obj.start_time, '00:00'
    assert_equal obj.end_time, '24:00'
    assert_equal obj.average_velocity, 55
  end

  def test_constructor_nils
    obj = Trip.new(nil,nil,nil)

    assert_nil obj.start_time
    assert_nil obj.end_time
    assert_nil obj.average_velocity
  end


  ###
  # Method Tests
  ###
  # Tests: #Trip.tripDurationInMinutes
  # Note- ':xx', 'xx:x', 'xx:', and negative hours test cases were considered, but caught by regex.
  ###
  def test_duration_nil_start
    obj = Trip.new(nil,'24:00',55)

    assert_nil obj.tripDurationInMinutes
  end

  def test_duration_nil_end
    obj = Trip.new('00:00',nil,55)

    assert_nil obj.tripDurationInMinutes
  end

  def test_duration_nil_both
    obj = Trip.new(nil,nil,55)

    assert_nil obj.tripDurationInMinutes
  end

  def test_duration_generic
    obj = Trip.new('00:00','08:00',55)

    assert_equal obj.tripDurationInMinutes, (8*60)
  end

  def test_duration_start_before_end
    obj = Trip.new('12:00','13:00',55)

    assert_equal obj.tripDurationInMinutes, (60)
  end

  def test_duration_end_before_start
    obj = Trip.new('13:00','12:00',55)

    assert_equal obj.tripDurationInMinutes, (60)
  end

  def test_duration_single_hours_digit
    obj = Trip.new('0:00','5:00',55)

    assert_equal obj.tripDurationInMinutes, (5*60)
  end

  def test_duration_equal
    obj = Trip.new('5:00','5:00',55)

    assert_equal obj.tripDurationInMinutes, (0)
  end
end