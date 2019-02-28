require 'spec_helper'

RSpec.describe ReportsController, type: :controller do

    before(:all) do
        create(:user_type, role: "Admin")
        create(:user_type, role: "Employee")
        @admin = create(:user)
        @employee = create(:user, email: "employee@test.com", role: 2)
        @report = create(:report)
    end

    describe "POST #create" do
        context "Report created successful by an admin" do
            it "returns 201" do
                jwt = JwtService.encode(payload: {email: @admin.email, role: "Admin" })
                request.headers["Authorization"] = "Bearer "+ jwt
                params = { report: { start: "08:00", finish: "16:00" }, user_id: 2  }
                post :create, { params: params, format: JSON }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response["status"]).to eq(201)
            end
        end
        context "Report created unsuccessful" do
            it "returns 401 because an employee tried to create it" do
                jwt = JwtService.encode(payload: {email: @employee.email, role: "Employee" })
                request.headers["Authorization"] = "Bearer "+ jwt
                params = { report: { start: "08:00", finish: "16:00" }, user_id: 2  }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response["status"]).to eq(401)
                expect(parsed_response["message"]).to eq("You dont have permissions")
            end

            it "returns 404 because employee does not exist" do
                jwt = JwtService.encode(payload: {email: @admin.email, role: "Admin" })
                request.headers["Authorization"] = "Bearer "+ jwt
                params = { report: { start: "08:00", finish: "16:00" }, user_id: 4  }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response["status"]).to eq(404)
            end
            it "returns 403 because token is invalid" do
                request.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImJAYi5jb20iLCJyb2xlIjoiQWRtaW4iLCJleHAiOjE1NTEwNDQ3ODV9.wXKX6sAGaoroCGGVQAIOw7wXdGSD7CtvbqWPLwD1"
                params = { report: { start: "08:00", finish: "16:00" }, user_id: 2  }
                post :create, { params: params }
                parsed_response = JSON.parse(response.body)
                expect(parsed_response["status"]).to eq(403)
                expect(parsed_response["message"]).to eq("Invalid token")
            end
        end
    end

    describe "GET #index" do
        it "return all reports and status 200" do
            jwt = JwtService.encode(payload: {email: @employee.email, role: "Employee" })
            request.headers["Authorization"] = "Bearer "+ jwt
            params = { user_id: 1 }
            get :index, { params: params }
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(200)
            expect(parsed_response["reports"]).to_not be_empty
        end
        it "returns 403 because token is invalid" do
            request.headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImJAYi5jb20iLCJyb2xlIjoiQWRtaW4iLCJleHAiOjE1NTEwNDQ3ODV9.wXKX6sAGaoroCGGVQAIOw7wXdGSD7CtvbqWPLwD1"
            params = { user_id: 1 }
            get :index, { params: params }
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(403)
            expect(parsed_response["message"]).to eq("Invalid token")
        end
    end


    describe "PUT #update" do
        it "will update the report #1 and return status 200" do
            jwt = JwtService.encode(payload: {email: @admin.email, role: "Admin" })
            request.headers["Authorization"] = "Bearer "+ jwt
            params = { report: { start: "10:30", finish: "16:00" }, id: 1, user_id: 2  }
            put :update, { params: params } 
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(200)
        end

        it "will not update the report because of lack of permissions" do
            jwt = JwtService.encode(payload: {email: @employee.email, role: "Employee" })
            request.headers["Authorization"] = "Bearer "+ jwt
            params = { report: { start: "10:30", finish: "16:00" }, id: 1, user_id: 2  }
            put :update, { params: params } 
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(401)
        end
    end


    describe "DELETE #destroy" do
        it "will delete the report #1 and return status 200" do
            jwt = JwtService.encode(payload: {email: @admin.email, role: "Admin" })
            request.headers["Authorization"] = "Bearer "+ jwt
            params = { id: 1, user_id: 2  }
            delete :destroy, { params: params } 
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(200)
        end

        it "will not delete the report because of lack of permissions" do
            jwt = JwtService.encode(payload: {email: @employee.email, role: "Employee" })
            request.headers["Authorization"] = "Bearer "+ jwt
            params = { id: 1, user_id: 2  }
            delete :destroy, { params: params } 
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["status"]).to eq(401)
        end
    end



    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end

end
