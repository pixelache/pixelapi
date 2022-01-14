# frozen_string_literal: true

# RSpec.describe  'Festivals API' do
require 'swagger_helper'

RSpec.describe 'Festivals API' do
  # save_rswag_examples!

  path '/v1/festivals' do
    get 'Retrieve all published festivals' do
      description 'Returns a paginated array of all published festivals in the database'
      tags 'Festivals'
      produces 'application/json'
      consumes 'application/json'
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1,
                required: false, in: :query
      parameter name: 'page[size]', type: :number,
                description: 'The number of festivals per page to return. Defaults to 10.', default: 10, required: false, in: :query

      before do
        create_list(:festival, 2, published: true)
        create_list(:festival, 1, published: false)
      end

      response 200, 'Festivals returned', save_response: true do
        run_test! do |_response|
          expect(json['data'].size).to eq 2
        end
      end
    end
  end

  path '/v1/festivals/{id}' do
    parameter name: :id, in: :path, type: :string, required: true
    let(:festival) { FactoryBot.create(:festival) }
    let(:id) { festival.id }

    get 'Retrieve one festival' do
      description 'Returns one festival record by ID or slug'
      tags 'Festivals'
      produces 'application/json'
      consumes 'application/json'

      response 200, 'Festival retrieved', save_response: true do
        run_test!
      end

      response 404, 'Not found', save_response: true do
        let(:id) { "#{festival.slug}322" }
        run_test!
      end
    end
  end
end
# end
