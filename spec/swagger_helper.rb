# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'
  config.include RequestSpecHelper
  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.after do |example|
    if example.metadata[:type] == :request && !example.metadata[:response].nil?
      if response.body.length > 1
        example.metadata[:response][:examples] = { "application/json" => JSON.parse(response.body, symbolize_names: true) }
      end
    end

    request_example_name = example.metadata[:save_request_example]
    if request_example_name && respond_to?(request_example_name)
      param = example.metadata[:operation][:parameters].detect { |p| p[:name] == request_example_name }
      param[:schema][:example] = send(request_example_name)
    end
  end
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger:             '2.0',
      info:                {
        title:       'Trenox API V1',
        description: 'API documentation for the forthcoming Trenox API which will drive numerous Trenox services.',
        version:     'v1'
      },
      securityDefinitions: {
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
      security:            [
        { client: [] },
        { uid: [] },
        { 'Access-Token': [] }
      ],
      definitions:         {
        errors_object:       {
          type:       'object',
          properties: {
            errors: { '$ref' => '#/definitions/errors_map' }
          }
        },
        errors_map:          {
          type:                 'object',
          additionalProperties: {
            type:  'array',
            items: { type: 'string' }
          }
        },
        bundle_object:       {
          type:       'object',
          properties: {
            id:          { type: :number },
            name:        { type: :string },
            client_id:   { type: :number },
            client_type: { type: :string },
            is_rented:   { type: :boolean }
          },
          required:   %w[name]
        },
        minutes_object:       {
          type:       'object',
          properties: {
            minutes: { type: :number }
          },
          required: %w[minutes]
        },
        bundling_object:     {
          type:       'object',
          properties: {
            id:              { type: :number },
            device_id:       { type: :number },
            simple_name:     { type: :string },
            http_port:       { type: :number },
            rtsp_port:       { type: :number },
            onvif_port:      { type: :number },
            camera_username: { type: :string },
            camera_password: { type: :string },
            embed_code:      { type: :string },
            comments:        { type: :string }
          },
          required:   %w[device_id]
        },
        feedback_object:     {
          type:       'object',
          properties: {
            message: { type: :string }
          },
          required:   %i[message]
        },
        comment_object:      {
          type:       'object',
          properties: {
            body:       { type: :string },
            attachment: { type: :string, format: :byte }
          },
          required:   %w[body]
        },
        document_object:     {
          type:       'object',
          properties: {
            name:        { type: :string },
            description: { type: :string },
            author:      { type: :string },
            comments:    {
              type:  :array,
              items: {
                type:       'object',
                properties: {
                  body:       { type: :string },
                  attachment: { type: :string, format: :byte }
                }
              }
            }
          },
          required:   %w[name attachment]
        },
        taskdetail_object:   {
          type:       'object',
          properties: {
            translations: {
              type:  :array,
              items: {
                type:       'object',
                properties: {
                  locale: { type: :string, length: 2 },
                  name:   { type: :string }
                },
                required:   %w[locale name]
              }
            }
          }
        },
        location_object:     {
          type:       'object',
          properties: {
            name:                  { type: :string },
            description:           { type: :string },
            ne_lat:      { type: :number },
            ne_lng:     { type: :number },
            sw_lat:  { type: :number },
            sw_lng: { type: :number },
            starred: { type: :boolean },
            image:                 { type: :string, format: :byte }
          },
          required:   %w[name]
        },
        crane_object:        {
          type:       'object',
          properties: {
            name:           { type: :string },
            worksite_id:    { type: :number },
            trenox_id:      { type: :string },
            manufacturer:   { type: :string },
            model:          { type: :string },
            height:         { type: :number },
            jib_length:     { type: :number },
            backjib_length: { type: :number },
            latitude:       { type: :number },
            longitude:      { type: :number }
          },
          required:   %w[name trenox_id worksite_id manufacturer model]
        },
        reservation_object:  {
          type:       'object',
          properties: {
            start_at:           { type: :string },
            end_at:             { type: :string },
            worksite_id:        { type: :number },
            notes:              { type: :string },
            taskdetail_id:      { type: :number },
            start_location_id:  { type: :number },
            end_location_id:    { type: :number },
            status:             { type: :number },
            priority:           { type: :boolean }
          },
          required:   %w[start_at end_at worksite_id]
        },
        organization_object: {
          type:       'object',
          properties: {
            name:     { type: :string },
            number:   { type: :string },
            address1: { type: :string },
            address2: { type: :string },
            city:     { type: :string },
            country:  { type: :string, length: 2 },
            postcode: { type: :string }
          },
          required:   %w[name city country address1]
        },
        worksite_object:     {
          type:       'object',
          properties: {
            name:     { type: :string },
            number:   { type: :string },
            address1: { type: :string },
            address2: { type: :string },
            city:     { type: :string },
            country:  { type: :string, length: 2 },
            postcode: { type: :string }
          },
          required:   %w[name city country]
        },
        liftrequest_object:  {
          type:       'object',
          properties: {
            worksite_id:       { type: :number },
            start_location_id: { type: :number },
            end_location_id:   { type: :number },
            booked_for:        { type: :string },
            notes:             { type: :string },
            status:            { type: :number },
            completed_by_id:   { type: :number },
            priority:          { type: :boolean },
            completed_at:      { type: :string },
            taskdetail_id:     { type: :number },
            comments:          {
              type:  :array,
              items: {
                type:       'object',
                properties: {
                  body:       { type: :string },
                  attachment: { type: :string, format: :byte }
                }
              }
            }
          }
        },
        device_object:       {
          type:       'object',
          properties: {
            devicetype_id:   { type: :number },
            trenox_sn:       { type: :string },
            manufacturer_sn: { type: :string },
            model:           { type: :string },
            comments:        { type: :string }
          },
          required:   %w[devicetype_id trenox_sn manufacturer_sn]
        },
        snapshot_object:     {
          type:       'object',
          properties: {
            start_at: { type: :string },
            end_at:   { type: :string }
          }
        },
        devicetype_object:   {
          type:       'object',
          properties: {
            id:   { type: :number },
            code: { type: :string },
            name: { type: :string }
          },
          required:   %w[code name]
        },
        deployment_object:   {
          type:       'object',
          properties: {
            id:          { type: :number },
            bundle_id:   { type: :number },
            can_record:  { type: :boolean },
            remote_view: { type: :boolean },
            active:      { type: :boolean },
            is_rented:   { type: :boolean },
            ip_address:  { type: :string }
          },
          required:   %w[bundle_id ip_address]
        },
        todo_object:         {
          type:       'todo',
          properties: {
            description: { type: :string },
            done:        { type: :boolean },
            latitude1:   { type: :number },
            longitude1:  { type: :number },
            latitude2:   { type: :number },
            longitude2:  { type: :number },
            attachment:  { type: :string, format: :byte },
            user_ids:    {
              type:  :array,
              items: {
                type: :number
              }
            }
          },
          required:   %w[description]
        },
        user_object:         {
          type:       'object',
          properties: {
            email:      { type: :string },
            password:   { type: :string },
            first_name: { type: :string },
            last_name:  { type: :string },
            phone:      { type: :string },
            language:   { type: :string, length: 2 },
            avatar:     { type: :string, format: :byte },
            remove_avatar: { type: :boolean }
          },
          required:   %w[first_name last_name email language]
        },
        viewing_object:      {
          type:       'object',
          properties: {
            user_id:       { type: :number },
            deployment_id: { type: :number },
            full:          { type: :boolean }
          },
          required:   %w[deployment_id user_id]
        }
      },
      paths:               {}
    }
  }
end
