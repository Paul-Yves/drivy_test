require_relative './rental'
module RentalManager

  # convert json list of rentals to list of rental objects
  def self.generate_rentals(rental_json_list, cars)
    rental_json_list.map{|json_rental| Rental.new(json_rental, cars)}
  end

  # returns a list of hashes corresponding the the detailed output of all rentals
  def self.detailed_output(rentals)
    rentals.map{|rental| rental.generate_output_detail}
  end

  # add modifications to rentals, execute them and return a detailed output of modified data
  # @param rentals[Array] - array of Rental objects
  # @param modifications[Array] - array of hashes for modifications
  def self.modified_output(modifications, rentals)
    modifications.map do |modif|
      target_rental = rentals.find{|rental| rental.id == modif['rental_id']}
      raise Exception("Missing rental #{modif['rental_id']} for modif #{modif['id']}") unless target_rental
      target_rental.modify(modif)
    end
  end

end