module FixnumExt
  refine Fixnum do
    SECONDS_CONST = 60
    SECONDS_IN_HOUR = 60 * SECONDS_CONST
    SECONDS_IN_DAY = 24 * SECONDS_IN_HOUR

    def days
      self * SECONDS_IN_DAY
    end

    def hours
      self * SECONDS_IN_HOUR
    end

    def minutes
      self * SECONDS_CONST
    end

    def ago
      Time.now - self
    end

    def from_now
      Time.now + self
    end
  end
end

class Api
  using FixnumExt
end