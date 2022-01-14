# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Events API', type: :request do
  path '/v1/events/{id}' do
    parameter name: :id, in: :path, type: :number,
              description: 'The database ID of the event you wish to retrieve data for'
    get 'Retrieve a single event' do
      description 'Returns the full record of a single event containing all possible associated data.'
      tags 'Events'
      produces 'application/json'
      consumes 'application/json'
      let(:id) { FactoryBot.create(:event).id }

      after do |example|
        example.metadata[:response][:examples] =
          { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Event returned', save_response: true do
        run_test!
      end
    end
  end

  path '/v1/events' do
    get 'Retrieve a list of events' do
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1,
                required: false, in: :query
      parameter name: 'page[size]', type: :number,
                description: 'The number of events per page to return. Defaults to 10.', default: 10, required: false, in: :query
      description 'Returns a paginated array of all events, paginated. Not specific to a project/festival/residency.'
      tags 'Events'
      produces 'application/json'
      consumes 'application/json'

      before do
        create_list(:event, 17)
        FactoryBot.create(:event, published: false)
      end

      response 200, 'Events returned', save_response: true do
        let('page[number]') { 2 }

        run_test! do
          expect(json['data'].size).to eq 7
        end
      end
    end
  end
end
