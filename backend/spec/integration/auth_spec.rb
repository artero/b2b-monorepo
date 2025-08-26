require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/auth/sign_in' do
    post('Sign in') do
      tags 'Authentication'
      description 'Sign in with email and password to get authentication tokens'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            description: 'Customer user email',
            example: 'user@example.com'
          },
          password: {
            type: :string,
            description: 'User password',
            example: 'password123'
          }
        },
        required: [ 'email', 'password' ]
      }

      response(200, 'successful') do
        let(:user) { create(:customer_user, password: 'password123', password_confirmation: 'password123') }
        let(:credentials) { { email: user.email, password: 'password123' } }

        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     email: { type: :string },
                     name: { type: :string },
                     surname: { type: :string },
                     provider: { type: :string },
                     uid: { type: :string }
                   },
                   required: %w[id email name surname provider uid]
                 }
               },
               required: %w[data]

        run_test! do |response|
          expect(response.headers['access-token']).to be_present
          expect(response.headers['client']).to be_present
          expect(response.headers['uid']).to eq(user.email)
        end
      end

      response(401, 'unauthorized') do
        let(:credentials) { { email: 'invalid@example.com', password: 'wrongpassword' } }

        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 errors: {
                   type: :array,
                   items: { type: :string },
                   example: [ 'Invalid login credentials. Please try again.' ]
                 }
               },
               required: %w[success errors]

        run_test!
      end
    end
  end


  path '/health' do
    get('Health check') do
      tags 'System'
      description 'Check system health status'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 status: { type: :string, example: 'ok' },
                 timestamp: { type: :string, example: '2023-01-01T00:00:00Z' },
                 services: {
                   type: :object,
                   properties: {
                     database: { type: :string, example: 'ok' }
                   }
                 }
               },
               required: %w[status]

        run_test!
      end
    end
  end
end
