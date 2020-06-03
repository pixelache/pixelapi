# frozen_string_literal: true

# RSpec.describe  'Festivals API' do
  require 'swagger_helper'

  RSpec.describe 'Festivals API' do
    # save_rswag_examples!

    path '/v1/festivals' do
      get 'Retrieve all published festivals' do
        description 'Returns an array of all published festivals in the database'
        tags 'Festivals'
        produces 'application/json'
        consumes 'application/json'
        
        before do
          create_list(:festival, 2, published: true)
          create_list(:festival, 1, published: false)
        end

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        
        response 200, 'Festivals returned' do
          run_test! do |response|
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

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        
        response 200, 'Festival retrieved' do
          run_test! 
        end
        
        response 404, 'Not found' do
          let(:id) { festival.slug + '322' }
          run_test!
        end
      end
    end
  end
# end