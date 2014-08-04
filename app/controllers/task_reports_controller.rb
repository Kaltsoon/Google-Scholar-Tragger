class TaskReportsController < ApplicationController

	def create
		report = TaskReport.new(report: params[:report], task_id: params[:task_id], user_id: session[:user_id])
		if report.save
			render json: { task_report_id: report.id }
		end
	end

	def update
		report = TaskReport.find(params[:task_report_id])

		report.update_attributes(report: params[:report], completed: params[:completed])
	end

	def destroy
    	report = TaskReport.find(params[:id])
    	user = report.user
		report.destroy
    	
    	redirect_to user_path(user)
 	end

end