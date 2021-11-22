require 'swagger_helper'

RSpec.describe 'Projects API', type: :request do
  path '/v1/projects/{id}' do
    put 'Update a project' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :project, in: :body, schema: { '$ref': '#/components/schemas/project' }
      description 'Updates a project definition.'
      tags 'Projects'
      produces 'application/json'
      consumes 'application/json'

      let(:id) { FactoryBot.create(:project).id }
      let(:project) { { project: { name: 'Updated project name' } } }
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 200, 'Project successfully updated.', save_response: true do
        run_test! do |_response|
          expect(json['data']['attributes']['name']).to eq 'Updated project name'
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
        before do
          other = FactoryBot.create(:project, name: 'Updated project name')
        end
        run_test!
      end
    end
  end

  path '/v1/projects' do
    post 'Create a project' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :project, in: :body, schema: { '$ref': '#/components/schemas/project' }
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }
      description 'Create a new project.'
      tags 'Projects'
      produces 'application/json'
      consumes 'application/json'
      let(:project) do
        { project: { active: true, name: Faker::Books::Lovecraft.tome,
                     background: "data:image/jpeg;base64,#{Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/images/background.jpg'), &:read))}", project_bg_colour: Faker::Color.hex_color, project_text_colour: Faker::Color.hex_color, project_link_colour: Faker::Color.hex_color, hidden: false, translations_attributes: [{ short_description: Faker::Lorem.paragraph(sentence_count: 4), description: Faker::Lorem.paragraph(sentence_count: 4), locale: 'en' }] } }
      end

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      response 201, 'Project has been created', save_response: true do
        run_test! do |_response|
          expect(json['data']['attributes']['background_url']).not_to be nil?
          expect(json['data']['attributes']['name']).to eq project[:project][:name]
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

    get 'Retrieve all projects' do
      description 'Returns a paginated array of all projects in the database'
      parameter name: 'page[number]', type: :number, description: 'The page of results to return.', default: 1,
                required: false, in: :query
      parameter name: 'page[size]', type: :number,
                description: 'The number of events per page to return. Defaults to 10.', default: 10, required: false, in: :query
      tags 'Projects'
      produces 'application/json'
      consumes 'application/json'

      before do
        create_list(:project, 5)
        FactoryBot.create(:project, hidden: true)
      end

      response 200, 'Projects returned', save_response: true do
        run_test! do
          expect(json['data'].size).to eq 5
        end
      end
    end
  end

  # path '/v1/projects/{id}' do

  # end
end
