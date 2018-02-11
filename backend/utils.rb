module Utils

  # returns the number of days spent in a slice
  # @param day[integer] - the total of days
  # @param start_day[integer] - the start of the slice of days
  # @param end_day[integer] - the end of the slice of days
  def self.days_for_slice(day, start_day, end_day)
    if day < start_day
      return 0
    end
    [end_day - start_day, day - start_day].min
  end


  # returns the opposite type of payment for a specific type
  def self.opposite_payment_type(type)
    if type == 'credit'
      'debit'
    else
      'credit'
    end
  end
end