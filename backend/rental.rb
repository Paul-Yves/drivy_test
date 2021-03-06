require 'date'
require_relative './car'
require_relative './utils'

# A class that hold information about renting a particular car
class Rental
  attr_reader :id

  def initialize(json_rental, car_list)
    @id = json_rental['id']
    @car = car_list.find{|car| car.id == json_rental['car_id']}
    raise Exception("No matching car for id #{json_rental['car_id']}") unless @car
    @distance = json_rental['distance']
    @start_date = Date.parse(json_rental['start_date'])
    @end_date = Date.parse(json_rental['end_date'])
    @deductible_reduction = json_rental['deductible_reduction']

    # computing some advanced attributes
    @price = @car.renting_price(rental_days, @distance)
    @commission = compute_commission
  end

  # recompute rental modification and provide a delta hash to settle the modification for each actor
  def modify(json_modifications)
    # store the old output
    @old_output = generate_output_detail # we store it as attribute in case we want some history
    old_actions = @old_output['actions']

    # modify rental attributes if needed
    @start_date = Date.parse(json_modifications['start_date']) if json_modifications['start_date']
    @end_date = Date.parse(json_modifications['end_date']) if json_modifications['end_date']
    @distance = json_modifications['distance'] if json_modifications['distance']

    # recompute calculated attributes and generate the new output
    @price = @car.renting_price(rental_days, @distance)
    @commission = compute_commission

    new_output = generate_output_detail

    #creating the delta output
    {
        'id' => json_modifications['id'],
        'rental_id' => @id,
        'actions' => new_output['actions'].each_with_index.map{ |actor, idx|
          amount = actor['amount'] - old_actions[idx]['amount']
          type = if amount > 0
                   actor['type']
                 else
                   Utils::opposite_payment_type(actor['type'])
                 end
          {'who' => actor['who'], 'type' => type, 'amount' => amount.abs}
        }
    }
  end

  # generate a hash representing the amount to debit/credit for each actor of the rental
  def generate_output_detail
    actions = [
        {'who' => "driver", 'type' =>"debit", 'amount' => (@price + deductible_price).round},
        {'who' => "owner", 'type' =>"credit", 'amount' => (0.7 * @price).round},
        {'who' => "insurance", 'type' =>"credit", 'amount' => @commission[:insurance_fee].round},
        {'who' => "assistance", 'type' =>"credit", 'amount' => @commission[:assistance_fee].round},
        {'who' => "drivy", 'type' =>"credit", 'amount' => (@commission[:drivy_fee] + deductible_price).round},
    ]
    {'id' => @id, 'actions' => actions}
  end

  private

  # number of days the rental last
  def rental_days
    1 + (@end_date - @start_date).to_i
  end

  # the deductible price is 400 * rental_days if we do the deductible reduction
  # it goes directly to drivy so it's not included in the @price
  def deductible_price
    (400 * rental_days if @deductible_reduction).to_i
  end

  # 30% of price divided between actors, returned as a dict of the division
  def compute_commission
    base = @price * 0.3
    assistance_fee = 100 * rental_days
    remaining = base / 2 - assistance_fee
    {insurance_fee: base / 2, assistance_fee: assistance_fee, drivy_fee: remaining}
  end



end