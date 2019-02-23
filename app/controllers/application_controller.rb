class ApplicationController < ActionController::API

    def get_jwt
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        return header.gsub(pattern, '') if header && header.match(pattern)
    end

    def check_jwt
        token = get_jwt
        @user = JwtService.decode(token: token)
    rescue
        render json: { status: 403, message: "Invalid token"}
    end

    def check_admin
        token = get_jwt
        info = JwtService.decode(token: token)
        if (info["role"] == "Employee")
            render json: { status: 401, message: "You dont have permissions"}
        end
    rescue ::JWT::VerificationError
        render json: { status: 403, message: "Invalid token"}
    end

end