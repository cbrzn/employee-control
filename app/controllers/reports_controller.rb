class ReportsController < ApplicationController
    before_action :check_jwt, only: [:index]
    before_action :check_admin, only: [:create, :update, :destroy, :show]

    def create
        user = User.find(params[:user_id])
        report = user.reports.build(report_params)
        if report.save!
            render json: { status: 201 }
        end
    rescue ::ActiveRecord::RecordNotFound
        render json: { status: 404, message: "User does not exist" }
    rescue ::ActiveRecord::RecordInvalid
        render json: { status: 406, message: "Start cannot be later that finish" }
    end
     
    def index
        user_id = User.find_by(email: @user["email"]).id
        reports = (@user["role"] == "Employee") ? Report.where(user_id: user_id).select("reports.id, users.name, start, finish").joins("INNER JOIN users ON users.id = reports.user_id") : Report.all.select("reports.id, users.name, start, finish").joins("INNER JOIN users ON users.id = reports.user_id")
        render json: { status: 200, reports: reports }
    end

    def show
        report = Report.find(params[:id])
        finish = (report.finish  ===  nil) ? 'N/A' : report.finish
        render json: { status: 200, start: report.start, finish: finish }
    rescue ::ActiveRecord::RecordNotFound
        render json: { status: 404, message: "Report not found"}
    end

    def update
        report = Report.find(params[:id]) 
        report.update_attributes(report_params)
        if report.save!
            render json: { status: 200 }
        end
    rescue  => e
        render json: { status: 406, message: "Start cannot be later that finish" }
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
