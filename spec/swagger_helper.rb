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
  config.swagger_format = :yaml
  config.after do |example|
    if respond_to?(:response) && response&.body.present?
      if response.status != 204 && example.metadata[:save_response]
        example.metadata[:response][:content] = {
          'application/json' => { example: JSON.parse(response.body, symbolize_names: true) }
        }
      end
    end
    if example.metadata[:type] == :request && !example.metadata[:response].nil?
      # if response.body.length > 1
      #   example.metadata[:response][:examples] = { "application/json" => JSON.parse(response.body, symbolize_names: true) }
      # end
      request_example_name = example.metadata[:save_request_example]
      if request_example_name && respond_to?(request_example_name)
        # pp JSON.pretty_generate(example.metadata)
        param = example.metadata[:operation][:parameters].find {|p| p[:name] == request_example_name }
        # example.metadata[:requestBody] = Hash.new{|h,k| h[k] = h.dup.clear }
        # pp JSON.pretty_generate(example.metadata[:operation][:parameters][0].inspect)
        example.metadata[:operation][:parameters][0][:requestExample] = send(request_example_name)
        # pp JSON.pretty_generate(example.metadata[:operation][:parameters][0].inspect)
      end
    end
    # request_example_name = example.metadata[:save_request_example]
    # # if request_example_name && respond_to?(request_example_name)
    # #   param = example.metadata[:operation][:parameters].detect { |p| p[:name] == request_example_name }
    # #   param[:schema][:example] = send(request_example_name)
    # # end
  end
    
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
          residency: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              country: { type: :string, length: 2 },
              start_at: { type: :string },
              end_at:  { type: :string },
              is_micro: { type: :boolean },
              photo: { type: :string, format: :byte },
              project_id: { type: :string },
              user_id: { type: :string },
              country_override: { type: :string }
            }
          },
          contributor: {
            type: :object,
            properties: { 
              id: { type: :number, description: 'The ID# of the contributor, if a PUT/update request. For a POST/create request do not include',example: 14},
              name: { type: :string, example: 'Jackson Pollock', description: 'The name of the contributor.' },
              alphabetical_name: { type: :string, example: 'Pollock, Jackson', description: 'The name by which the contributor should be alphabeticised.'},
              bio: {type: :string, example: 'Jackson Pollock (January 28, 1912 - August 11, 1956), was an influential American painter and a major figure in the abstract expressionist movement. During his lifetime, Pollock enjoyed considerable fame and notoriety. He was regarded as a mostly reclusive artist.', description: 'A short biography of the contributor.'},
              website: { type: :string, example: 'https://www.jackson-pollock.org/', description: 'The website URL of the contributor.'},
              image: { type: :string, format: :byte, description: 'An image of the contributor. Can be sent as binary using form-data, or as a base64-encoded string.' }
            },
            required: %w[name alphabetical_name]
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
