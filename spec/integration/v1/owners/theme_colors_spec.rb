require 'swagger_helper'

RSpec.describe 'v1/owners/theme_colors', swagger_doc: 'v1/swagger_owner.yaml', type: :request do
  TAG_NAME = 'ThemeColors'.freeze
  let(:color_count) { rand(1..10) }
  let(:user) { create(:owner) }
  let(:Authorization) { authentication(user) }

  path '/v1/owners/theme_colors' do
    get 'All colors' do
      before { create_list(:theme_color, color_count) }
      tags TAG_NAME
      produces 'application/json'
      security [bearer: []]

      response 200, 'return array' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/theme_color'
                   }
                 }
               }

        run_test! do
          expect(json_body.dig('data').length).to eq(color_count)
        end
      end
    end
  end
end
