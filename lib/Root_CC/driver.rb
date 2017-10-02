require_relative './trip'

class Driver
  attr_accessor :name
  attr_accessor :registered
  attr_accessor :trips

  # Constructor -- initialize registered = false && trips = [] if not passed
  def initialize(name, registered = false, trips=Array.new)
    @name       = name
    @registered = registered
    @trips      = trips
  end

  # Get a filtered list of #trips based on filtering from #validTrip
  def selectValidTrips
    if !@trips.nil?
      return @trips.select{|trip| validTrip(trip)}
    else
      return nil
    end
  end

  # Get average velocity of all valid, filtered trips from #selectValidTrips
  def averageTripVelocity
    filtered_trips = selectValidTrips
    if !filtered_trips.nil? && filtered_trips.any?
      filtered_trips.inject(0){ |sum, trip| sum + trip.average_velocity} / filtered_trips.size
    else
      return 0
    end
  end

  # Aggregate the total distance traveled by all valid, filtered trips from #selectValidTrips.
  def totalLengthOfTrips
    filtered_trips = selectValidTrips
    if !filtered_trips.nil? && filtered_trips.any?
      return filtered_trips.inject(0){|sum,trip| sum + ((trip.average_velocity * trip.tripDurationInMinutes) / 60) }
    else
      return 0
    end
  end

  # Definition of if a trip is valid or not.  Should be between the minimum and maximum velocities configured. Extensible to add different criterion in future.
  def validTrip trip
    return trip.average_velocity.between?(HELPER.config_min_velocity, HELPER.config_max_velocity)
  end
end