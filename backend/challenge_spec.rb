require 'json'
require_relative './car'
require_relative './rental'
require_relative './rental_manager'

RSpec.describe 'drivy challenge' do
  describe "level 5" do
    it "RentalManager::detailed_output match output.json" do
      data = JSON.parse(File.read('./level5/data.json'))
      cars = data['cars'].map{|car_data| Car.new(car_data)}
      rentals = RentalManager::generate_rentals(data['rentals'], cars)
      result = { 'rentals' => RentalManager::detailed_output(rentals)}
      output = JSON.parse(File.read('./level5/output.json'))
      File.write('./level5/result.json', JSON.pretty_generate(result))
      expect(result).to eq(output)
    end
  end

  describe "level 6" do
    it "RentalManager::modified_output match output.json" do
      data = JSON.parse(File.read('./level6/data.json'))
      cars = data['cars'].map{|car_data| Car.new(car_data)}
      rentals = RentalManager::generate_rentals(data['rentals'], cars)
      deltas = RentalManager::modified_output(data['rental_modifications'], rentals)
      result = {'rental_modifications' => deltas}
      output = JSON.parse(File.read('./level6/output.json'))
      File.write('./level6/result.json', JSON.pretty_generate(result))
      expect(result).to eq(output)
    end
  end
end