class ReportsController < ApplicationController
    before_action :check_jwt, only: [:index]
    before_action :check_admin, only: [:create, :update, :destroy]

    def create
        user = User.find(params[:user_id])
        report = user.reports.build(report_params)
        if report.save
            render json: { status: 201 }
        else
            render json: { status: 500 }
        end
    rescue ::ActiveRecord::RecordNotFound
        render json: { status: 404, message: "User does not exist" }
    end
     
    def index
        user_id = User.find_by(email: @user["email"]).id
        reports = (@user["role"] == "Employee") ? Report.where(user_id: user_id) : Report.all
        render json: { status: 200, reports: reports }
    end

    def update
        report = Report.find(params[:id]) 
        report.update_attributes(report_params)
        if report.save
            render json: { status: 200 }
        end
    rescue 
        render json: { status: 500 }
    end

    def destroy
        report = Report.find(params[:id])
        if report.destroy
            render json: { status: 200 }
        end
    rescue
        render json: { status: 500 }
    end

    private

        def report_params
            params.require(:report).permit(:user_id, :start, :finish)
        end

end
