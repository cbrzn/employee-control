class UsersController < ApplicationController
    before_action :check_admin, only: [:update]
    
    def create 
        user = User.new(user_params)
        if user.save!
            role = UserType.find(user.role).role
            jwt = JwtService.encode(payload: { "email" => user.email, "role" => role })  
            render json: { status: 200, jwt: jwt }
        end
    rescue ::ActiveRecord::RecordInvalid => e
        puts e
        if e.to_s == "Validation failed: Email has already been taken"
            render json: { status: 406, error: "Email is already registered"}
        elsif e.to_s == "Validation failed: Password can't be blank"
            render json: { status: 422, error: "Password can\'t be blank"}
        elsif e.to_s == "Validation failed: Name can't be blank"
            render json: { status: 422, error: "Name can\'t be blank"}
        end
    end

    
    def show
        user = User.find(params[:id])
        render json: {status: 200 , user: user }
    rescue
        render json: {status: 404 }
    end
    
    def index
        users = User.where(role: 2).select("id, name, email, created_at")
        render json: {status: 200, users: users }
    end

    def update
        user = User.find(params[:id])
        user.update_attributes(role: params["role"])
        if user.save!
            render json: {status: 200}
        end
    rescue => e
        puts e
        render json: {status: 500 }
    end

    def destroy
        user = User.find(params[:id])
        if user.destroy!
            render json: { status: 200 }
        end
    rescue ::ActiveRecord::RecordNotFound
            render json: { status: 404 }
    end

    private

        def user_params
            params.require(:user).permit(:email, :name, :password, :password_confirmation, :role)
        end
end
