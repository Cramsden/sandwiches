require 'json'

module Sammies
  class EntityWriter
    attr_reader :keys

    def initialize(keys)
      @keys = keys
    end

    def write_to_file(path)
      output = path + '/sammy_seeds.json'
      File.open(output, 'w') do |file|
        file.write JSON.pretty_generate gathered_entities
      end
      puts "😎\s Sammy Seeds written to #{output} 😎"
    end

    private
    def gathered_entities
      keys.each_with_object({}) do |key, memo|
        number_of_entities = Faker::Number.between(300,400)
        puts "### Generating #{key} with #{number_of_entities} entities ###"
        memo[key.to_sym] = Sammies::EntityCollection.new(number_of_entities).collection
      end
    end
  end
end
