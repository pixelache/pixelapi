# frozen_string_literal: true

require 'rails_helper'
require 'pp'
RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'
  config.include RequestSpecHelper
  config.include RswagExampleHelpers
  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'



    # if there's no response metadata, we can assume we're not in RSwag territory
    # unless example.metadata[:response].nil?
    #   example.metadata[:response][:content] = {
    #     example.metadata[:operation][:produces].first => {
    #       schema: example.metadata[:response][:schema]
    #     }
    #   }
    # end
  # end

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      # swagger: '2.0',
      openapi: '3.0.1',
      info: {
        title: 'Pixelache API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'api.pixelache.ac'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
