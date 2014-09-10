class TaskReportsController < ApplicationController

	include DataFormatter

	def create
		report = TaskReport.new(report: params[:report], task_id: params[:task_id], user_id: session[:user_id], started: params[:started])
		if report.save
			render json: { task_report_id: report.id }
		end
	end

	def update
		report = TaskReport.find(params[:task_report_id])

		report.update_attributes(report: params[:report], completed: params[:completed], item_height: params[:item_height], form_height: params[:form_height], items:  params[:items])
	end

	def destroy
    	report = TaskReport.find(params[:id])
    	user = report.user
		report.destroy
    	
    	redirect_to user_path(user)
 	end

 	def download_task_report
 		task_report = TaskReport.find(params[:task_report_id])
 		all_reports = task_report.user.task_reports.order(started: :desc)
 		filename = "#{task_report.task.description.gsub(/\s+/, "_")}_#{task_report.id}_data.csv"

 		user_zip()

 		#if(params[:include] == "queries")
 		#	send_data(task_report_queries_data(task_report), filename: filename)
 		#elsif(params[:include] == "clicks")
 		#	send_data(task_report_clicks_data(task_report), filename: 'clicks.csv')
 		#else
 		#	send_data(task_report_summary(task_report), filename: "#{task_report.user.name}_#{task_report.task.task_code || '?'}_#{all_reports.index(task_report) + 1}.csv")
 		#end
 	end

end