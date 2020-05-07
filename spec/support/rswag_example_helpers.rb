# frozen_string_literal: true

module RswagExampleHelpers

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def save_rswag_examples!
      after(:each) do |example|
        if response.body.length > 1
          example.metadata[:response][:content] = {
            'application/json' => JSON.parse(response.body, symbolize_names: true)
          }
        end

        # Can only record one example for requests, so only save successful examples
        next unless example.metadata[:responses][:code].to_s.match?(/^2/)
        next unless example.metadata[:operation][:parameters]
        example.metadata[:operation][:parameters].each do |parameter|
          # Some parameters are optional and are not defined for all tests
          next unless respond_to?(parameter[:name])
          value = send(parameter[:name])
          case parameter[:in]
          when :body
            if parameter[:schema] && parameter[:schema][:$ref]
              ref_name = parameter[:schema][:$ref]
                .sub(/^#\/components\/schemas\//, '').to_sym
              definition = RSpec.configuration.swagger_docs['v1/swagger.yaml'][:components][:schemas][ref_name]
              definition[:example] ||= JSON.pretty_generate(value.as_json)
            else

              parameter[:schema][:example] ||= JSON.pretty_generate(value.as_json) 
            end
          else
            parameter[:'x-example'] ||= value
          end
        end
      end
    end
  end
end