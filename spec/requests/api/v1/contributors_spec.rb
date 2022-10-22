# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Contributors API', type: :request do

  path '/v1/projects/{project_id}/contributors' do
    parameter name: :project_id, in: :path, type: :number, required: true
    get 'Retrieve all contributors for a project' do
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1, required: false, in: :query
      parameter name: 'page[size]', type: :number, description: 'The number of contributors per page to return. Defaults to 10.', default: 10, required: false, in: :query
      description 'Retrieves all contributors for a project. Requires the project ID and will be paginated 10 per page by default.'
      tags 'Contributors', 'Projects'
      produces 'application/json'
      consumes 'application/json'
      let(:project) { create(:project) }
      let(:project_id) { project.id }
      
      before do
        #  create > 10 contributors for the festival
        cs = create_list(:contributor, 13)
        cs.each do |c|
          c.projects << project
        end
      end

      response 200, 'Contributors successfully retrieved.', save_response: true do
        let('page[number]') { 2 }
        run_test! do |response|
          expect(json['data'].count).to eq 3
        end
      end

      response 404, 'Not found', save_response: true do
        let(:project_id) { 23_423_423 }
        run_test!
      end
    end
  end

  path '/v1/events/{event_id}/contributors' do
    parameter name: :event_id, in: :path, type: :number, required: true
    get 'Retrieve all contributors for an event' do
      description 'Retrieves all contributors for an event. Not paginated.'
      tags 'Contributors', 'Events'
      produces 'application/json'
      consumes 'application/json'
      let(:event) { create(:event) }
      let(:event_id) { event.id }
      
      before do
        #  create > 10 contributors for the festival
        cs = create_list(:contributor, 3)
        cs.each do |c|
          c.events << event
        end
      end

      response 200, 'Contributors successfully retrieved.', save_response: true do
        run_test! do |response|
          expect(json['data'].count).to eq 3
        end
      end

      response 404, 'Not found', save_response: true do
        let(:event_id) { 23_423_423 }
        run_test!
      end
    end
  end

  path '/v1/festivals/{festival_id}/contributors' do
    parameter name: :festival_id, in: :path, type: :number, required: true
    get 'Retrieve all contributors for a festival' do
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1, required: false, in: :query
      parameter name: 'page[size]', type: :number, description: 'The number of contributors per page to return. Defaults to 10.', default: 10, required: false, in: :query
      description 'Retrieves all contributors for a festival (regardless of themes). Requires the festival ID and will be paginated 10 per page by default.'
      tags 'Contributors', 'Festivals'
      produces 'application/json'
      consumes 'application/json'
      let(:festival) { create(:festival) }
      let(:festival_id) { festival.id }
      
      before do
        #  create > 10 contributors for the festival
        cs = create_list(:contributor, 13)
        cs.each do |c|
          c.festivals << festival
        end
      end

      response 200, 'Contributors successfully retrieved.', save_response: true do
        run_test! do |response|
          expect(json['data'].count).to eq 10
        end
      end

      response 404, 'Not found', save_response: true do
        let(:festival_id) { 23_423_423 }
        run_test!
      end
    end
  end

  path '/v1/festivals/{festival_id}/festivalthemes/{id}/contributors' do
    parameter name: :festival_id, in: :path, type: :number, required: true
    parameter name: :id, in: :path, type: :number, required: true
    get 'Retrieve all contributors for a festival theme' do
      description 'Retrieves all contributors for a festival theme. Requires the festival ID and festival theme ID in the path.'
      tags 'Contributors', 'Festivals'
      produces 'application/json'
      consumes 'application/json'
      let(:festival) { create(:festival) }
      let(:festival_theme) { create(:festivaltheme, festival: festival) }
      let(:festival_id) { festival.id }
      let(:id) { festival_theme.id }
      #  create an event for the festival
      let(:event) { create(:event, :with_festival, festival: festival) }
      
      before do
        event.festivalthemes << festival_theme
        cs = create_list(:contributor, 3)
        cs.each do |c|
          c.events << event
          c.festivalthemes << festival_theme
        end
      end

      response 200, 'Contributors successfully retrieved.', save_response: true do
        run_test! do |response|
          expect(json['data'].count).to eq 3
        end
      end

      response 404, 'Not found', save_response: true do
        let(:id) { 23_423_423 }
        run_test!
      end
    end

  end

  path '/v1/contributors/{id}' do
    parameter name: :id, in: :path, type: :string, required: true, description: 'The ID # or database slug of a contributor to retrieve'
    get 'Retrieve a single contributor' do
      description 'Retrieves a single contributor from the database by ID # or slug.'
      tags 'Contributors'
      produces 'application/json'
      consumes 'application/json'
      let(:id) { FactoryBot.create(:contributor).id }

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 200, 'Contributor successfully retrieved.', save_response: true do
        run_test! do |_response|
          expect(json['data']['attributes']['name']).not_to be nil
        end
      end

      response 404, 'Not found', save_response: true do
        let(:id) { 23_423_423 }
        run_test!
      end
    end

    put 'Update a contributor' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :contributor, in: :body, schema: { '$ref': '#/components/schemas/contributor' }
      description 'Updates a contributor description.'
      tags 'Contributors'
      produces 'application/json'
      consumes 'application/json'

      let(:id) { FactoryBot.create(:contributor).id }
      let(:project) { FactoryBot.create(:project) }
      let(:festival) { FactoryBot.create(:festival) }
      let(:festival_themes) { FactoryBot.create_list(:festivaltheme, 2, festival: festival) }
      let(:event) { FactoryBot.create(:event) }
      let(:residency) { FactoryBot.create(:residency) }
      let(:contributor) do
        { contributor: { name: 'David Atlee Phillips', alphabetical_name: 'Phillips, David Atlee', project_ids: [project.id],
                         residency_ids: [residency.id], event_ids: [event.id], festivaltheme_ids: festival_themes.map(&:id), festival_ids: [festival.id] } }
      end
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 200, 'Contributor successfully updated.', save_response: true, save_request_example: :contributor do
        run_test! do |_response|
          expect(json['data']['attributes']['name']).to eq 'David Atlee Phillips'
          expect(json['included']).not_to be_empty
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

      response 422, 'Invalid/unprocessible data' do
        before do
          other = FactoryBot.create(:contributor, name: 'David Atlee Phillips')
        end
        run_test!
      end
    end
  end

  path '/v1/contributors' do
    post 'Create a contributor' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :contributor, in: :body, schema: { '$ref': '#/components/schemas/contributor' }
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }
      description 'Create a new contributor.'
      tags 'Contributors'
      produces 'application/json'
      consumes 'application/json'
      let(:contributor) do
        { contributor: { active: true, name: Faker::Name.name, alphabetical_name: Faker::Name.name,
                         image: "data:image/jpeg;base64,#{Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/images/background.jpg'), &:read))}", bio: Faker::Lorem.paragraph(sentence_count: 4) } }
      end

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] =
          { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Contributor has been created' do
        run_test! do |_response|
          expect(json['data']['attributes']['image']).not_to be nil?
          expect(json['data']['attributes']['name']).to eq contributor[:contributor][:name]
        end
      end

      response 401, 'Not authenticated' do
        let(:uid) { '' }
        run_test!
      end

      response 403, 'Not authorized' do
        before do
          user2 = FactoryBot.create(:user, :confirmed)
          @auth_headers = user2.create_new_auth_token
        end
        run_test!
      end
    end

    get 'Retrieve all contributors' do
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1, required: false, in: :query
      parameter name: 'page[size]', type: :number, description: 'The number of contributors per page to return. Defaults to 10.', default: 10, required: false, in: :query

      description 'Returns an array of all contributors in the database'
      tags 'Contributors'
      produces 'application/json'
      consumes 'application/json'

      before do
        create_list(:contributor, 3)
      end

      after do |example|
        example.metadata[:response][:examples] =
          { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Contributors returned' do
        run_test! do |_response|
          expect(json['data'].size).to eq 3
        end
      end
    end
  end
end
