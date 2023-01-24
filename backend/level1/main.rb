# Require json gem to manipulate json files and date gem to manipulate dates
require "json"
require "date"

# Reading the json input file and parsing it into a hash
file = File.read('data/input.json')
input_hash = JSON.parse(file)

# Saving cars and rentals information into two separate arrays
cars_array = input_hash["cars"]
rentals_array = input_hash["rentals"]

# Rental_length method calculates the rental number of days
def rental_length(rental_hash)
  (Date.parse(rental_hash["end_date"]) - Date.parse(rental_hash["start_date"]) + 1).to_i
end

# Price calculation method return the price_per_day and price_per_km of a rental
def price_calculation(cars_array, rental_hash)
  price_per_day = 0
  price_per_km = 0
  # Iteration over cars_array to find the rental matching car with its id
  # When the right car is found, we retrieve the price_per_day and price_per_km
  cars_array.each do |car_hash|
    price_per_day = car_hash["price_per_day"] if rental_hash["car_id"] == car_hash["id"]
    price_per_km = car_hash["price_per_km"] if rental_hash["car_id"] == car_hash["id"]
  end
  # We return a hash containing the rental price_per_day and price_per_km
  {
    price_per_day: price_per_day,
    price_per_km: price_per_km
  }
end

# total_price method return the total price of a rental
def total_price(price_per_day, price_per_km, number_of_days, total_distance)
  number_of_days * price_per_day + total_distance * price_per_km
end

# rentals_output return an array of rental hashes with only id and price information
def rentals_output(rentals_array, cars_array)
  rentals_output = []
  # Iteration over rentals to
  rentals_array.each do |rental|
    # define total price inputs
    price_per_day = price_calculation(cars_array, rental)[:price_per_day]
    price_per_km = price_calculation(cars_array, rental)[:price_per_km]
    number_of_days = rental_length(rental)
    total_distance = rental["distance"]
    # create a hash containing only rental id and price information
    rental_hash = {
      "id": rental["id"],
      "price": total_price(price_per_day, price_per_km, number_of_days, total_distance)
    }
    # this hash is pushed into rentals_output array
    rentals_output << rental_hash
  end
  # rentals_output array contains rental hashes
  rentals_output
end

# json_output method create the json output file with the right format
def json_output(rentals_output)
  output_file = {
    "rentals": rentals_output
  }
  File.write('data/output.json', JSON.dump(output_file))
end

# Creating the rental_output array containing hashes with id and price for each rental
rentals_output = rentals_output(rentals_array, cars_array)

# Creating the json output file
json_output(rentals_output)
