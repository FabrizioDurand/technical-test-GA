require './json_methods'

class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(params = {})
    @id = params[:id]
    @price_per_day = params[:price_per_day]
    @price_per_km = params[:price_per_km]
  end

  # Class list saving all cars objects into cars array
  def self.cars_list
    cars = []
    JsonMethods.json_to_hash('data/input.json')["cars"].each do |car|
      cars << Car.new(id: car["id"], price_per_day: car["price_per_day"], price_per_km: car["price_per_km"])
    end
    cars
  end
end
