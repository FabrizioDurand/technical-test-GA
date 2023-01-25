require './json_methods'

class Option
  attr_reader :id, :rental, :type

  def initialize(params = {})
    @id = params[:id]
    @rental = params[:rental]
    @type = params[:type]
  end

  # Class list saving all cars objects into cars array
  def self.options_list
    options = []
    JsonMethods.json_to_hash('data/input.json')["options"].each do |option|
      options << Option.new(id: option["id"], rental: option["rental_id"], type: option["type"])
    end
    options
  end
end
