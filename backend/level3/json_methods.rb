# Require json gem to manipulate json files
require 'json'


class JsonMethods
  # Class method converting a Json file to a hash
  def self.json_to_hash(filepath)
    file = File.read(filepath)
    JSON.parse(file)
  end

  # Class method converting a hash to a Json file
  def self.json_output(filepath, objects_array)
    # output_hash format the desired output
    output_hash = {
      "rentals": objects_array.map do |x|
        # .output method convert object to hash of attributes
        x.output
      end
    }
    # Json file is written in the filepath given
    File.write(filepath, JSON.dump(output_hash))
  end
end
