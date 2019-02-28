require 'spec_helper'

RSpec.describe Report, type: :model do

    before(:all) do
        create(:user_type, role: "Admin")
        create(:user_type, role: "Employee")
        @admin = create(:user)
        @employee = create(:user, email: "employee@test.com", role: 2)
        @report = create(:report)
    end

    it "is valid with valid attributes" do
        expect(@report).to be_valid
    end

    it "is unvalid because it needs to be assigned to an user" do
        unvalid_report = build(:report, user_id: "")
        expect(unvalid_report).to_not be_valid
    end

    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end


end
