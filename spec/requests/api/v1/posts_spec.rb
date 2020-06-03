# frozen_string_literal: true


require 'swagger_helper'

RSpec.describe 'Posts API'  do
  # save_rswag_examples!

  path '/v1/posts' do

    post 'Create a new post' do
      security [client: [], 'Access-Token': [], uid: []]
      parameter name: :blogpost, in: :body, schema: { '$ref': '#/components/schemas/post'}
      let(:client) { @auth_headers['client'] }
      let('Access-Token') { @auth_headers['access-token'] }
      let(:uid) { @auth_headers['uid'] }
      description 'Create a new post'
      tags 'Posts'
      produces 'application/json'
      consumes 'application/json'
      let(:blogpost) { { post: { published: true, image: "data:image/jpeg;base64,#{Base64.encode64(File.open(File.join(Rails.root, "/spec/fixtures/images/gaddis.jpg"), &:read))}", translations_attributes: [ {title: Faker::Book.title, body: Faker::Lorem.paragraph(sentence_count: 2), locale: 'en'}] } } }

      before do
        @user = FactoryBot.create(:user, :member)
        @auth_headers = @user.create_new_auth_token
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 201, 'Post has been created' do
        run_test! do |response|
          expect(json['data']['attributes']['image_url']).not_to be nil?
          expect(json['data']['attributes']['title']).to eq blogpost[:post][:translations_attributes][0][:title]
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

    get 'Retrieve all posts' do
      description 'Returns all posts of a sub-site (paginated)'
      tags 'Posts'
      produces 'application/json'
      consumes 'application/json'

      before do
        create_list(:post, 15, subsite_id: 1, published: true)
      end

      after do |example|
        example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
      end

      response 200, 'Posts returned' do
        run_test! do |response|
          expect(json['data'].size).to eq 12
        end
      end
    end
  end
  
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
        create_list(:post, 5, subsite_id: 1, festival: festival, published: true)
        create_list(:post, 2, subsite_id: 1, festival: festival, published: false)
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
