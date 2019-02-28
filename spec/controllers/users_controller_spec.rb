require 'spec_helper'

RSpec.describe UsersController, type: :controller do
    before(:all) do
        create(:user_type, role: "Admin")
        create(:user_type, role: "Employee")
        @user = create(:user)
    end
    describe "POST #create" do
        context "when the params are correct" do
            it "returns status 200" do
                params = { user: { email: "asd@asd.com", password: "test", role: 2} }
                jwt = JwtService.encode(payload: {"email": "asd@asd.com", "role": "Employee" })
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(200)
                expect(parsed_response['jwt']).to eq(jwt)
            end
        end

        context "when the params are not correct" do
            it "returns status 406 because email is already registered" do
                params = { user: { email: "admin@test.com", password: "a", role: 1} }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(406)
            end

            it "returns status 422 because password is empty" do
                params = { user: { email: "a@ab.com", password: "", role: 1} }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response['status']).to eq(422)
            end
        end
    end 

    describe "GET #show" do
        it "returns existing user" do
            params = { id: 1 }
            get :show, { params: params }
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['status']).to eq(200)
            expect(parsed_response['user']).to_not be_nil
        end

        it "returns 404 because user does not exist" do 
            params = { id: 89 }
            get :show, { params: params }
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['status']).to eq(404)
        end
    end

    describe "GET #index" do
        it "return employees" do
            get :index
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['status']).to eq(200)
            expect(parsed_response['users']).to eq([])
        end
    end
    
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
end
