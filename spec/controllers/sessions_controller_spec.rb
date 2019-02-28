require 'spec_helper'

RSpec.describe SessionsController, type: :controller do
    
    before(:all) do
        create(:user_type, role: "Admin")
        create(:user_type, role: "Employee")
        @user = create(:user)
    end

    describe "POST #login" do
        context "User exist and params are good" do
            it "returns status 200 and JWT" do
                params = { email: "admin@test.com", password: "a" }
                jwt = JwtService.encode(payload: {"email": "admin@test.com", "role": "Admin" })
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(200)
                expect(parsed_response['jwt']).to eq(jwt)
            end
        end

        context "Password is wrong" do
            it "returns status 403" do
                params = { email: "admin@test.com", password: "asd" }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(403)
            end
        end

        context "Email is not registered" do
            it "returns status 404" do
                params = { email: "te@test.com", password: "a" }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(404)
            end
        end
    end

    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
    
end
