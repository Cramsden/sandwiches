require 'faker'

module Sammies
  class EntityCollection
    attr_reader :number_of_entities

    def initialize(number_of_entities)
      @number_of_entities = number_of_entities
    end

    def collection
      number_of_entities.times.collect do
        start = Faker::Date.backward(5)
        end_date = Faker::Date.forward(16)

        {
          name: Faker::Food.ingredient,
          detail: Faker::Lorem.sentence,
          amount: Faker::Number.between(1, 47),
          best_by: Faker::Date.between(start, end_date)
        }
      end
    end
  end
end
