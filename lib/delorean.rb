require 'chronic'

module Delorean
  extend self

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
    Time.now_without_delorean - time_travel_offsets.inject(0){ |sum, val| sum + val }
  end

  private

  def time_travel_offsets
    @@time_travel_offsets ||= []
  end

  def reset
    @@time_travel_offsets = []
  end

  def mock_current_time(time, options={})
    time = Chronic.parse(time, options) if time.is_a?(String)
    time = Time.local(time.year, time.month, time.day) if time.is_a?(Date) && !time.is_a?(DateTime)

    time_travel_offsets.push Time.now - time
  end

  def restore_previous_time
    time_travel_offsets.pop
  end
end

class << Time
  alias_method :now_without_delorean, :now
  def now; Delorean.now; end
end

if RUBY_VERSION >= "1.9.3"
  class << Date
    alias_method :today_without_delorean, :today

    def today(sg=Date::ITALY)
      t = Time.now
      Date.civil(t.year, t.mon, t.mday)
    end
  end
end
