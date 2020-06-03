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
      components: {
        securitySchemes: {
          client:         {
            in:   :header,
            name: :client,
            type: :apiKey
          },
          uid:            {
            in:   :header,
            type: :apiKey,
            name: :uid
          },
          "Access-Token": {
            in:   :header,
            type: :apiKey,
            name: 'Access-Token'
          }
        },
        schemas:  {
          errors_object: {
            type: 'object',
            properties: {
              errors: { '$ref' => '#/components/schemas/errors_map' }
            }
          },
          errors_map: {
            type: 'object',
            additionalProperties: {
              type: :array,
              items: { type: :string }
            }
          },
          attachments_attributes: { 
            type: :array,
            items: { 
              type: :object,
              properties: { 
                id: { type: :integer },
                documenttype_id: { type: :integer },
                attachedfile: { type: :string, format: :byte },
                _destroy: { type: :boolean },
                year_of_publication: { type: :integer },
                title: { type: :string },
                description: { type: :string },
                public: { type: :boolean }
              }
            }
          },
          photos_attributes: { 
            type: :array,
            items: { 
              type: :object,
              properties: { 
                id: { type: :integer },
                filename: { type: :string, format: :byte },
                title: { type: :string },
                credit: { type: :string },
                _destroy: { type: :boolean }
              }
            }
          },
          videos_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                in_url: { type: :string },
                _destroy: { type: :boolean }
              }
            }
          },
          project: { 
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              parent_id: { type: :integer },
              website: { type: :string },
              evolvedfrom_id: { type: :integer },
              hidden: { type: :boolean },
              project_bg_colour: { type: :string },
              project_text_colour: { type: :string },
              project_link_colour: { type: :string },
              redirect_to: { type: :string },
              background: { type: :string, format: :byte },
              evolution_year: { type: :string },
              active: { type: :boolean },
              remove_background: { type: :boolean },
              translations_attributes: { 
                type: :array,
                items: { 
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    description: { type: :string },
                    short_description: { type: :string },
                    locale: { type: :string, required: true }
                  }
                }
              },
              photos_attributes: {
                '$ref' => '#/components/schemas/photos_attributes'
              },
              attachments_attributes: {
                '$ref' => '#/components/schemas/attachments_attributes'
              },
              videos_attributes: {
                '$ref' => '#/components/schemas/videos_attributes'
              }
            }
          },
          post: {
            type: :object,
            properties: {
              id: { type: :integer },
              published: { type: :boolean },
              published_at: { type: :string },
              subsite_id: { type: :integer },
              project_id: { type: :integer },
              festival_id: { type: :integer },
              event_id: { type: :integer },
              residency_id: { type: :integer },
              post_category_ids: { 
                type: :array,
                items: { type: :integer }
              },
              image: { type: :string, format: :byte },
              translations_attributes: {
                type: :array,
                items: { 
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    locale: { type: :string, length: 2, required: true },
                    title: { type: :string, required: true },
                    body: { type: :string, required: true },
                    excerpt: { type: :string }
                  }
                }
              },
              photos_attributes: {
                '$ref' => '#/components/schemas/photos_attributes'
              },
              attachments_attributes: {
                '$ref' => '#/components/schemas/attachments_attributes'
              }
            }
          }
        }
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
