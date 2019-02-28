class SessionsController < ApplicationController

    def create
        user = User.find_by(email: params["email"]) ? User.find_by(email: params["email"]) : nil
        if (user)
            if (user.authenticate(params["password"]))
                role = UserType.find(user.role).role
                jwt = JwtService.encode(payload: { "email" => user.email, "role" => role })  
                render json: { jwt: jwt, status: 200 }
            else 
                render json: { status: 403, msg: 'Wrong password' }
            end
        else
            render json: { status: 404, msg: 'Email not registered' }
        end
    end

end