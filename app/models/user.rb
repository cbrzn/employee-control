class User < ApplicationRecord
    validates_uniqueness_of :email
    validates :name, presence: true
    has_secure_password
    has_one :user_type
    has_many :reports, dependent: :destroy
end
