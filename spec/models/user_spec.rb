require 'spec_helper'

RSpec.describe User, type: :model do
    before(:all) do
        create(:user_type, role: "Admin")
        create(:user_type, role: "Employee")
        @user = build(:user)
    end
    it "is valid with valid attributes" do 
        expect(@user).to be_valid
    end

    it "is unvalid because it needs password" do
        unvalid_user = build(:user, password: "")
        expect(unvalid_user).to_not be_valid
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end

end
