require_relative './utils'

class Car
  attr_reader :id

  def initialize(json_data)
    @id = json_data['id']
    @price_day = json_data['price_per_day']
    @price_km = json_data['price_per_km']
  end

  # compute the price to rent this car
  # @param rental_days[integer] - number of days the rental last
  # @param distance[integer] - distance made during rental
  def renting_price(rental_days, distance)
    reduc_1_days = Utils::days_for_slice(rental_days,1, 4)
    reduc_4_days = Utils::days_for_slice(rental_days,4, 10)
    reduc_10_days = [rental_days - 10, 0].max
    @price_day * (1 + reduc_1_days * 0.9 + reduc_4_days * 0.7 + reduc_10_days * 0.5) + @price_km * distance
  end
end