# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Memberships API' do
  # save_rswag_examples!

  path '/v1/memberships' do
    get 'Retrieve memberships' do
      description 'Returns a paginated array of all membership in the database'
      tags 'Memberships'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :by_year, type: :number, description: 'The year to return memberships from', required: false,
                in: :query
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1,
                required: false, in: :query
      parameter name: 'page[size]', type: :number,
                description: 'The number of memberships per page to return. Defaults to 10.', default: 10, required: false, in: :query

      before do
        Faker::UniqueGenerator.clear
        create_list(:membership, 2, hallitus: true)
        create_list(:membership, 7, hallitus: false)
        create_list(:membership, 3, year: Time.now - 3, hallitus: false)
        create_list(:membership, 5, year: Time.now - 3, hallitus: false)
      end

      response 200, 'Memberships returned', save_response: true do
        run_test! do |_response|
          expect(json['data'].size).to eq 10
        end
      end
    end
  end
end
