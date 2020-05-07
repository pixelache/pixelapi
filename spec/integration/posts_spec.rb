# frozen_string_literal: true


require 'swagger_helper'

RSpec.describe 'Posts API'  do
  # save_rswag_examples!
  path '/v1/festivals/{festival_id}/posts' do
    parameter name: :festival_id, in: :path, type: :number, required: true
    let(:festival) { FactoryBot.create(:festival) }
    let(:festival_id) { festival.id }

    get 'Retrieve all posts for a festival' do
      description 'Returns all published posts belonging to a festival.'
      tags 'Posts', 'Festivals'
      produces 'application/json'
      consumes 'application/json'

      before do
        Faker::UniqueGenerator.clear
        create_list(:post, 5, festival: festival, published: true)
        create_list(:post, 2, festival: festival, published: false)
      end
      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end
      response 200, 'Festival posts retrieved' do
        run_test! do |response|
          expect(json['data'].length).to eq 5
        end
      end
      
      response 404, 'Not found' do
        let(:festival_id) { festival.id + 322 }
        run_test!
      end
    end
  end
end
