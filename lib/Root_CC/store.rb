require 'singleton'
require_relative './driver'

# This module is used to allow access to the state of the driver report hash.  Implemented as a singleton for usage in multiple classes.
module Store
  # Hash object that manages the data model for drivers and trips
  @store = Hash.new()

  # Getter object for the #store
  def store
    return @store
  end

  ###
  # Module Functions
  ###
  # Driver Management Functions
  ##
  # Getter for a specific driver in the #store
  def self.driver driverName
    return @store[driverName]
  end

  # Adding a driver to the store.
  def self.insertDriver driver
    if !@store.has_key? driver.name
      @store[driver.name] = driver
    else
      puts "Driver: #{driver.name} already exists."
    end
  end

  # Getter to access if a given driver is registered or not.
  def self.driverRegistered driverName
    @store[driverName].registered
  end

  # Setter to register a non-registered driver
  def self.registerDriver driverName
    @store[driverName].registered = true
  end

  # Adding a new trip to an existing driver.
  def self.addTrip driver, trip
    @store[driver].trips = @store[driver].trips.push(trip)
  end

  # Helper method that return a list of all drivers sorted by #driver.totalLengthOfTrips.
  def self.sortedDrivers
    return @store.values.sort{|obj1,obj2| obj2.totalLengthOfTrips.to_f <=> obj1.totalLengthOfTrips.to_f}
  end

  ###
  # Store Management
  ###
  def self.contains key
    return @store.key?(key)
  end

  def self.size
    return @store.size
  end

  def self.clear
    @store.clear
  end
end