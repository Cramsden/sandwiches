require_relative 'entities/entity_collection'
require_relative 'entities/entity_writer'

module Sammies
  class API
    class << self
      def generate_data_to(keys, path)
          Sammies::EntityWriter.new(keys).write_to_file(path)
      end
    end
  end
end
