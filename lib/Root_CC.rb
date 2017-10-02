require_relative 'Root_CC/helper'

#####################################
## ROOT Insurance - Code Challenge ##
## Author: Bryan Lewis             ##
## Date: 10/02/2017                ##
## Version: 1.0.0                  ##
#####################################
# Primary driver class for project
def driver
  # Print Welcoming Output
  HELPER.printProjectOpening

  # Process each input argument to determine if it works
  processInputArgument

  # Prompt user for input and instructions, while input
  manageUserInputs

  # Print Exiting Output
  HELPER.printProjectClosing
end

# Method that will handle all input arguments that were passed in at runtime.
def processInputArgument
  ARGV.each do |argument|
    HELPER.processInputArgument(argument)
  end
end

# Function that will handle the flow for user input from the command line.
def manageUserInputs
  # Prompt user for configuration items for this program run
  processUserConfiguration

  # Process user CLI to manage flow of the application
  handleUserInput
end

# Method to handle user input setting configuration values
def processUserConfiguration
  ###
  # Have user configure minimum/maximum velocity|duration for a trip to be included
  ###
  ## Velocity
  # Minimum
  HELPER.printConfigVelocityMin
  user_config_velocity_min = STDIN.gets.strip

  if HELPER::REGEX_CONFIG_FLOAT =~ user_config_velocity_min
    HELPER.config_min_velocity = user_config_velocity_min.to_f
  end

  # Maximum -- make sure maximum >= minimum
  HELPER.printConfigVelocityMax
  user_config_velocity_max = STDIN.gets.strip

  if HELPER::REGEX_CONFIG_FLOAT =~ user_config_velocity_max
    user_config_velocity_max = user_config_velocity_max.to_f
    # If maxiumum is >= minimum, set it
    if user_config_velocity_max>= HELPER.config_min_velocity
      HELPER.config_max_velocity = user_config_velocity_max
    else # Otherwise loop until we get a valid input or escape case where default is set to min.
      acceptableMaximum = false
      loop do
        HELPER.printConfigVelocityMinMaxError(HELPER.config_min_velocity, user_config_velocity_max)
        user_config_velocity_max = STDIN.gets.strip

        # If a number we check if the input is still lower than the minimum, which forces them to input again.
        if HELPER::REGEX_CONFIG_FLOAT =~ user_config_velocity_max
          if user_config_velocity_max.to_f>= HELPER.config_min_velocity
            HELPER.config_max_velocity = user_config_velocity_max.to_f
            acceptableMaximum = true
          end
        else # Otherweise it's an exit case, which uses the default (minimum velocity)
          acceptableMaximum = true
          HELPER.config_max_velocity = user_config_velocity_min.to_f
        end

        break if acceptableMaximum
      end
    end
  else  # Otherwise set the maximum value to the default (max default if it's higher than the minimum, otherwise the minimum)
    HELPER.config_max_velocity = user_config_velocity_min.to_f>HELPER::CONFIG_DEFAULT_MAX_VELOCITY ? user_config_velocity_min : HELPER::CONFIG_DEFAULT_MAX_VELOCITY
  end
end

# Method that will handle command entry from user input via command line.
def handleUserInput
  # Print user instructions
  HELPER.printUserInstructions

  # Hold flag to manage when user wants to leave the project
  exitProgram = false

  # Loop while user wants to continue inputting commands
  loop do
    # Get user input
    userInput = STDIN.gets.strip

    # If input is nil we will generate the report
    if userInput.length == 0
      # Generate Report
      HELPER.printDriverReport

      # Prompt user to see if they want to continue inputting commands
      HELPER.printContinue
      continue = STDIN.gets.strip

      if(/^y/i=~continue)
        # If the user wants to continue we will prompt them to see if they want to clear the current store
        HELPER.printContinueClear
        clearStore = STDIN.gets.strip

        # If user wants to clear the store call store clear
        if(/^y/i=~clearStore)
          Store.clear

          # Check if there are any input arguments, if so ask if the user wants to reuse them on the cleared store
          if ARGV.size>0
            HELPER.printContinueArguments
            reimportArgs = STDIN.gets.strip

            if /^y/i=~reimportArgs
              processInputArgument
            end
          end
        end
        HELPER.printUserInstructions
      else
        # If user does not want to continue inputting commands we will exit the program.
        exitProgram = true
      end
    else # If the input is not nil we can assume the user is trying to input a command.
      # Process input to see if it's a valid command.
      HELPER.processInput(userInput)
    end

    break if exitProgram
  end
end

driver