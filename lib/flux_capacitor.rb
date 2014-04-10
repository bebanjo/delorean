
module Delorean
  module FluxCapacitor
    def time_travel_to(time, options={})

      mock_current_time(time, options)
      return unless block_given?
      begin
        yield
      ensure
        restore_previous_time
      end
    end

    def back_to_the_present
      reset
    end
    alias :back_to_1985 :back_to_the_present

    def jump(seconds)
      mock_current_time Time.now + seconds

      return unless block_given?
      begin
        yield
      ensure
        restore_previous_time
      end
    end



    def now
      return frozen_time if frozen_time
      Time.now_without_delorean - time_travel_offsets.inject(0){ |sum, val| sum + val }
    end

    def freeze_time(time = Time.now, options={})
      
      mock_current_time time, options
      @@frozen_time =  Time.now

    end

    private
    def frozen_time
      @@frozen_time ||= false
    end
    def time_travel_offsets
      @@time_travel_offsets ||= []
    end

    def reset
      @@time_travel_offsets = []
      unfreeze_time
    end

    def mock_current_time(time, options={})
      
      time = Chronic.parse(time, options) if time.is_a?(String)
      time = Time.local(time.year, time.month, time.day) if time.is_a?(Date) && !time.is_a?(DateTime)
      unfreeze_time
      time_travel_offsets.push Time.now - time
      

    end

    def restore_previous_time
      time_travel_offsets.pop
    end

    def unfreeze_time
      @@frozen_time = nil
    end
  end
end

