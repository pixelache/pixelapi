require 'swagger_helper'

RSpec.describe 'Residencies API', type: :request do
  path '/v1/residencies/{id}' do
    put 'Update a residency' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :residency, in: :body, schema: { '$ref': '#/components/schemas/residency' }
      description 'Updates a residency.'
      tags 'Residencies'
      produces 'application/json'
      consumes 'application/json'

      let(:id) { FactoryBot.create(:residency).id }
      let(:residency) { { residency: { name: 'Firstname Surname' } } }
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 200, 'Residency successfully updated.', save_response: true do
        run_test! do
          expect(json['data']['attributes']['name']).to eq 'Firstname Surname'
        end
      end

      response 401, 'Not authenticated', save_response: true do
        let(:uid) { '' }
        run_test!
      end

      response 403, 'Not authorized', save_response: true do
        before do
          user2 = FactoryBot.create(:user, :confirmed)
          @auth_headers = user2.create_new_auth_token
        end
        run_test!
      end

      response 404, 'Not found', save_response: true do
        let(:id) { 23_423_423 }
        run_test!
      end

      response 422, 'Invalid/unprocessible data', save_response: true do
        let(:residency) { { residency: { country: '', country_override: '' } } }
        run_test!
      end
    end
  end

  path '/v1/residencies' do
    post 'Create a residency' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :residency, in: :body, schema: { '$ref': '#/components/schemas/residency' }
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }
      description 'Create a new residency.'
      tags 'Residencies'
      produces 'application/json'
      consumes 'application/json'
      let(:residency) do
        { residency: { start_at: Faker::Date.backward(days: 4000), end_at: Faker::Date.forward(days: 23),
                       name: Faker::Books::Lovecraft.tome, photo: "data:image/jpeg;base64,#{Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/images/artist.jpg'), &:read))}", country: 'ES', is_micro: false, translations_attributes: [{ short_description: Faker::Lorem.paragraph(sentence_count: 4), description: Faker::Lorem.paragraph(sentence_count: 4), locale: 'en' }] } }
      end

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 201, 'Residency has been created', save_response: true do
        run_test! do |_response|
          expect(json['data']['attributes']['photo_url']).not_to be nil?
          expect(json['data']['attributes']['name']).to eq residency[:residency][:name]
        end
      end

      response 401, 'Not authenticated', save_response: true do
        let(:uid) { '' }
        run_test!
      end

      response 403, 'Not authorized', save_response: true do
        before do
          user2 = FactoryBot.create(:user, :confirmed)
          @auth_headers = user2.create_new_auth_token
        end
        run_test!
      end
    end

    get 'Retrieve all residencies' do
      description 'Returns a paginated array of all residencies in the database'
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1,
                required: false, in: :query
      parameter name: 'page[size]', type: :number,
                description: 'The number of events per page to return. Defaults to 10.', default: 10, required: false, in: :query
      tags 'Residencies'
      produces 'application/json'
      consumes 'application/json'

      before do
        create_list(:residency, 3)
      end

      response 200, 'Residencies returned', save_response: true do
        run_test! do |_response|
          expect(json['data'].size).to eq 3
        end
      end
    end
  end

  # path '/v1/residencies/{id}' do

  # end
end
