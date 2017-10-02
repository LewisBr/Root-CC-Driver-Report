require_relative './store'

# Helper module that houses dumb components and constants
module HELPER
  ###
  # CONFIGURATION_HELPERS
  ###
  ## Configuration for trip exclusion based on criteria
  # Default values that a are for trip inclusion
  CONFIG_DEFAULT_MIN_VELOCITY = 5.0         # Default value for minimum include trip velocity. (If no user input)
  CONFIG_DEFAULT_MAX_VELOCITY = 100.0       # Default value for maximum include trip velocity. (If no user input)

  ### Actual accessor values for determining if to include trip
  ### **Note** On getters if there is no set value just use the default.
  # Minimum Velocity
  def self.config_min_velocity
    if @config_min_velocity.nil?
      return CONFIG_DEFAULT_MIN_VELOCITY
    else
      return @config_min_velocity
    end
  end

  def self.config_min_velocity=(input)
    @config_min_velocity = input.to_f
  end

  # Maximum Velocity
  def self.config_max_velocity
    if @config_max_velocity.nil?
      return CONFIG_DEFAULT_MAX_VELOCITY
    else
      return @config_max_velocity.to_f
    end
  end

  def self.config_max_velocity=(input)
    @config_max_velocity = input
  end

  ###
  # REGEX HELPERS
  ###
  # Regex for driver is insensitive 'driver ' followed by alphabetical(and spaces) followed by at least one alpha character and then allow spaces
  REGEX_DRIVER = /^(?:driver )([a-zA-Z]+(?:(?:[',. -][a-zA-Z ])?[a-zA-Z]*))$/is

  # Regex for trip is grouped as the following with a single space in-between each group:
  # 1) word 'Trip' case insensitive *Not a capture group*
  # 2) Regex block for a name. Matches the regex block from #REGEX_DRIVER's second clause
  # 2) Regex block for HH:MM that also accepts H:MM
  # 3) Regex block for HH:MM that also accepts H:MM
  # 4) Regex block that accepts \d | \d. | \d.\d* | .\d*
  REGEX_TRIP = /^trip ([a-zA-Z]+(?:(?:[',. -][a-zA-Z ])?[a-zA-Z]*)) ((?:[0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]) ((?:[0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]) ((?:[0-9]*[.])?[0-9]+)$/is

  # Regex for determining if user input for configuration is a number
  REGEX_CONFIG_FLOAT = /^(?:[0-9]*[.])?[0-9]+/

  # Regex helper methods
  def self.stripDriverFromDriverInput input = ""
    if REGEX_DRIVER =~ input
      return input.match(REGEX_DRIVER).captures[0]
    else
      return nil
    end
  end

  def self.tripCaptures input = ""
    if REGEX_TRIP =~ input
      return input.match(REGEX_TRIP).captures
    else
      return nil
    end
  end

  ###
  # INPUT HELPERS
  ###
  ROOT_PATH = File.expand_path(File.dirname(__FILE__))

  def self.processInputArgument input_argument
    ###
    # Case for input argument is being a file to process
    ###
    if File.file?(input_argument)
      puts "Processing Input File: '#{input_argument}'"
      input=File.open(input_argument).read
      input.each_line do |current_line|
        processInput(current_line)
      end
    else
      puts "Unknown Input Argument: '#{input_argument}'"
    end
  end

  def self.processInput input
    # Strip input from leading/trailing whitespace
    input = input.strip

    # Check if input command is for registering a new Driver
    if(REGEX_DRIVER=~input)
      # Get driver name from input
      driverName = stripDriverFromDriverInput(input)

      # If the user doesn't exist in the store add a new driver.
      if !Store.contains(driverName)
        newDriver = Driver.new(driverName,true,[])
        Store.insertDriver(newDriver)
      elsif !Store.driverRegistered(driverName)
        Store.registerDriver(driverName)
      else
        puts "Driver by the name of #{driverName} already exists."
      end
    elsif(REGEX_TRIP=~input) # Check if input is for registering a new trip for a driver
      # Get the capture groups [0] = Driver | [1] = Start | [2] = End | [3] = Velocity
      tripCaptures = tripCaptures(input)
      newTrip = Trip.new(tripCaptures[1],tripCaptures[2],tripCaptures[3].to_f)
      # If the user exists in the database just add the new trip to the user
      if Store.contains tripCaptures[0].strip
        Store.addTrip(tripCaptures[0], newTrip)
      else # Otherwise create a new driver that is not registered.
        driver = Driver.new(tripCaptures[0],false,[newTrip])
        Store.insertDriver(driver)
      end
    else
      puts "Input of '#{input}' does not match any known command."
    end
  end

  ###
  # OUTPUT HELPERS
  ###
  ## Static Text to be displayed in various cases
  OPENING_TXT = "#########################\n" +
                "## ROOT CODE CHALLENGE ##\n" +
                "## Author: Bryan Lewis ##\n" +
                "#########################"

  CLOSING_TXT = "###################################\n" +
                "## Program Closing               ##\n" +
                "## Thanks for your consideration ##\n" +
                "###################################"

  USER_INPUT_CONFIG_VELOCITY_MIN = "What is the minimum average velocity that should be included? (Default = #{CONFIG_DEFAULT_MIN_VELOCITY})"

  USER_INPUT_CONFIG_VELOCITY_MAX = "What is the maximum average velocity that should be included? (Default = %s)"

  USER_INPUT_CONFIG_MIN_GREATHER_THAN_MAN = "The maximum velocity ('%s') needs to be higher than the lower velocity '%s'.\nPlease insert a number higher than %s, or nothing to default to %s"

  USER_INPUT_INSTRUCTIONS = "Please enter registration commands for user or trip. Entering with no input will generate a report on the registered input."

  USER_INPUT_CONTINUE = "Would you like to continue registering commands? (Yes/No)"

  USER_INPUT_CONTINUE_CLEAR = "Would you like to clear previous registration data? (Yes/No)"

  USER_INPUT_CONTINUE_ARGS = "Would you like to re-process input arguments? (Yes/No)"

  ###
  # Methods to handle outputting of above text.
  ###
  def self.printProjectOpening
    puts OPENING_TXT
  end

  def self.printProjectClosing
    puts CLOSING_TXT
  end

  def self.printConfigVelocityMin
    puts USER_INPUT_CONFIG_VELOCITY_MIN
  end

  def self.printConfigVelocityMax
    puts USER_INPUT_CONFIG_VELOCITY_MAX % [self.config_min_velocity>HELPER::CONFIG_DEFAULT_MAX_VELOCITY ? self.config_min_velocity : HELPER::CONFIG_DEFAULT_MAX_VELOCITY]
  end

  def self.printConfigVelocityMinMaxError(minimum, maximum)
    puts USER_INPUT_CONFIG_MIN_GREATHER_THAN_MAN % [maximum,minimum,minimum,minimum]
  end

  def self.printUserInstructions
    puts USER_INPUT_INSTRUCTIONS
  end

  def self.printContinue
    puts USER_INPUT_CONTINUE
  end

  def self.printContinueClear
    puts USER_INPUT_CONTINUE_CLEAR
  end

  def self.printContinueArguments
    puts USER_INPUT_CONTINUE_ARGS
  end

  ## Driver Report Output
  def self.printDriverReport
    puts  "###################################\n" +
          "## DRIVER REPORT\n" +
          "## Total Registered Drivers = #{Store.size}\n" +
          "## Minimum Speed = #{config_min_velocity}  || Maximum Speed = #{config_max_velocity}\n" +
          "###################################"

    # Get sorted drivers list, and then filter the list to only drivers that are registered
    drivers = Store.sortedDrivers.select{|driver| driver.registered}
    drivers.each{|driver| puts "#{driver.name}: #{driver.totalLengthOfTrips.to_i} miles#{driver.trips.size>0?" @ #{driver.averageTripVelocity.to_i} mph":""} (#{driver.selectValidTrips.size} #{driver.selectValidTrips.size==1?"trip":"trips"})"}

    puts  "###################################"
  end
end