class User < ApplicationRecord
    validates_uniqueness_of :email
    has_secure_password
    has_one :user_type
    has_many :reports
end
