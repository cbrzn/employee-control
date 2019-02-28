class UsersController < ApplicationController
    
    def create 
        user = User.new(user_params)
        if user.save!
            role = UserType.find(user.role).role
            jwt = JwtService.encode(payload: { "email" => user.email, "role" => role })  
            render json: { status: 200, jwt: jwt }
        else 
            render json: { status: 500, error: user.errors }
        end
    rescue ::ActiveRecord::RecordInvalid => e
        if e.to_s == "Validation failed: Email has already been taken"
            render json: { status: 406, error: "Email is already registered"}
        elsif e.to_s == "Validation failed: Password can't be blank"
            render json: { status: 422, error: "Password can\'t be blank"}
        end
    end

    def show
        user = User.find(params[:id])
        render json: {status: 200 , user: user }
    rescue
        render json: {status: 404 }
    end

    def index
        users = User.where(role: 2)
        render json: {status: 200, users: users }
    end

    private

        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :role)
        end
end
