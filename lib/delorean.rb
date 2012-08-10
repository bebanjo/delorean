require 'chronic'
require 'flux_capacitor'

module Delorean
  include FluxCapacitor
  extend self
end

class << Time
  alias_method :now_without_delorean, :now
  def now; self.at Delorean.now.to_f; end
end

if RUBY_VERSION >= "1.9.3"
  class << Date
    alias_method :today_without_delorean, :today

    def today(sg=Date::ITALY)
      t = Time.now
      self.civil(t.year, t.mon, t.mday, sg )
    end
  end

  class << DateTime
    alias_method :now_without_delorean, :now

    def now(sg=Date::ITALY)
      format = '%Q'
      self.strptime( Time.now.to_datetime.strftime(format), format, sg )
    end
  end
end
