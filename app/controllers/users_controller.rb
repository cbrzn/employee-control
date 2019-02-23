class UsersController < ApplicationController
    
    def create 
        user = User.new(user_params)
        if user.save!
            role = UserType.find(user.role).role
            jwt = JwtService.encode(payload: { "email" => user.email, "role" => role })  
            render json: { status: 200, jwt: jwt }
        else 
            render json: { status: 400, error: user.errors }
        end
    rescue ::ActiveRecord::RecordInvalid
        render json: { status: 403, error: 'Email already exists'}
    end

    def show
        user = User.find(params[:id])
        render json: {status: 200 , user: user }
    rescue
        render json: {status: 404 }
    end

    private

        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation, :role)
        end
end
