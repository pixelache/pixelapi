# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Open Calls API' do
  # save_rswag_examples!

  path '/v1/opencalls/{id}/opencallsubmissions' do
    parameter name: :id, in: :path, type: :string, required: true
    parameter name: :opencallsubmission, in: :body, required: true, schema: {}
    let(:opencall) { FactoryBot.create(:opencall) }
    let(:questions) do
      FactoryBot.create_list(:opencallquestion, 2, opencall: opencall, question_type: 2, is_required: true)
    end
    let(:file_question) { FactoryBot.create(:opencallquestion, opencall: opencall, question_type: 3) }
    let(:id) { opencall.slug }
    let(:opencallsubmission) do
      { opencallsubmission: { email: Faker::Internet.free_email, name: Faker::Name.name_with_middle, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.full_address, opencallanswers_attributes: questions.map do |q|
                                                                                                                                                                                                                 { opencallquestion_id: q.id, answer: Faker::Lorem.sentence }
                                                                                                                                                                                                               end.push({ opencallquestion_id: file_question.id, attachment: "data:image/jpeg;base64,#{Base64.encode64(File.open(File.join(Rails.root, '/spec/fixtures/images/gaddis.jpg'), &:read))}" }) } }
    end

    post 'Submit an open call' do
      description 'Submit one open call submission'
      tags 'Open Calls'
      produces 'application/json'
      consumes 'application/json'

      response 201, 'Open call submission successfully submitted', save_response: true do
        run_test! do |_response|
          expect(json['data']['attributes']['opencall_id']).to eq opencall.id
          expect(json['included'].size).to eq 3
        end
      end

      response 404, 'Not found', save_response: true do
        let(:id) { "#{opencall.slug}ffsfs" }
        run_test!
      end

      response 422, 'Unprocessible form', save_response: true do
        let(:opencallsubmission) do
          { opencallsubmission: { email: Faker::Internet.free_email, name: Faker::Name.name_with_middle,
                                  phone: Faker::PhoneNumber.phone_number, address: Faker::Address.full_address, opencallanswers_attributes: [{ opencallquestion_id: file_question.id, answer: 'should have attachment here' }] } }
        end
        run_test!
      end
    end
  end

  path '/v1/opencalls/{id}' do
    parameter name: :id, in: :path, type: :string, required: true
    let(:opencall) { FactoryBot.create(:opencall) }
    let(:id) { opencall.slug }

    get 'Retrieve one open call' do
      description 'Returns one open call by ID'
      tags 'Open Calls'
      produces 'application/json'
      consumes 'application/json'

      response 200, 'Open call retrieved', save_response: true do
        run_test!
      end

      response 404, 'Not found', save_response: true do
        let(:id) { "#{opencall.slug}322" }
        run_test!
      end
    end
  end
end
