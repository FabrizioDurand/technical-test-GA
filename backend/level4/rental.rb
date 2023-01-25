# Require date gem to manipulate dates
require 'date'

require './json_methods'
require './commission'
require './action'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance, :commission,
              :driver, :owner, :insurance, :assistance, :drivy

  def initialize(params = {})
    @id = params[:id]
    @car = params[:car]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @distance = params[:distance]
    commission
    action
  end

  # Class list saving all rentals objects into rentals array
  # Taskes cars (cars objects array) in argument to link it to the rental
  def self.rentals_list(cars)
    rentals = []
    # Iteration over json file to recover rental data
    JsonMethods.json_to_hash('data/input.json')["rentals"].each do |rental|
      # Looking for the rental car in cars
      rental_car = cars.find { |car| car.id == rental["car_id"]}
      # Creation of a new rental object and pushing it into rentals array
      rentals << Rental.new(
        id: rental["id"], car: rental_car,
        start_date: rental["start_date"], end_date: rental["end_date"],
        distance: rental["distance"]
      )
    end
    rentals
  end

  # output method format the desired output to be converted in json
  def output
    { "id": @id, "actions":
      [
        @driver.output,
        @owner.output,
        @insurance.output,
        @assistance.output,
        @drivy.output
      ] }
  end

  private

  # Rental_length method calculates the rental number of days
  def rental_length
    (Date.parse(end_date) - Date.parse(start_date) + 1).to_i
  end

  # total_price method return the total price of a rental
  def total_price
    days_price = 0
    # days_price will be the total day price according to the decrease price policy
    for i in (1..self.rental_length) do
      # price per day decreases by 50% after 10 days
      if i > 10
        days_price += car.price_per_day * (1 - 0.5)
      # price per day decreases by 30% after 4 days
      elsif i > 4
        days_price += car.price_per_day * (1 - 0.3)
      # price per day decreases by 10% after 1 day
      elsif i > 1
        days_price += car.price_per_day * (1 - 0.1)
      else
        days_price += car.price_per_day
      end
    end
    (days_price + distance * car.price_per_km).to_i
  end

  # commission method return a commission object
  # with insurance, assistance and drivy fee
  def commission
    commission_ratio = 0.3
    commission_price = (total_price * commission_ratio).to_i
    # assistance fee is set to 100€/day to match the expected output
    # in contradiction with the instructions where assistance fee is 1€/day
    roadside_assistance_fee = 100
    insurance_fee = commission_price / 2
    assistance_fee = rental_length * roadside_assistance_fee
    drivy_fee = commission_price - (insurance_fee + assistance_fee)
    @commission = Commission.new(
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    )
  end

  # action method will create action objects for each actor and save them to
  # instance variables
  def action
    @driver = Action.new({ who: "driver", type: "debit", amount: total_price })
    @owner = Action.new({ who: "owner", type: "credit", amount: (0.7 * total_price).to_i })
    @insurance = Action.new({ who: "insurance", type: "credit", amount: commission.insurance_fee })
    @assistance = Action.new({ who: "assistance", type: "credit", amount: commission.assistance_fee })
    @drivy = Action.new({ who: "drivy", type: "credit", amount: commission.drivy_fee })
  end
end
