class Trip
  attr_accessor :start_time
  attr_accessor :end_time
  attr_accessor :average_velocity

  def initialize(start_time, end_time, average_velocity)
    # If either start or end are nil just place them accordingly
    if start_time == nil || end_time == nil
      @start_time = start_time
      @end_time   = end_time
    else
    # Otherwise assign them to their min/max values so start is before end
      @start_time = [start_time, end_time].min
      @end_time   = [start_time, end_time].max
    end
    @average_velocity = average_velocity
  end

  def tripDurationInMinutes
    if @start_time==nil || @end_time==nil
      return nil
    else
      start_in_minutes = @start_time.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
      end_in_minutes = @end_time.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b}
      return (end_in_minutes - start_in_minutes)
    end
  end
end