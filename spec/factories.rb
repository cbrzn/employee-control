FactoryBot.define do

    factory :user do
        email { 'admin@test.com' }  
        password { 'a' }     
        role { 1 } 
    end

    factory :user_type do

    end

    factory :report do
        start { '10:00' }
        finish { '18:00' }
        user_id { 2 }
    end
end