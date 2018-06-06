require_dependency "jobstat/application_controller"

module Jobstat
  class JobAnalysisController < ApplicationController
    def show
      @job = Job.find(params["id"])

      @thresholds_conditions = @job.get_thresholds_conditions()
      @primary_conditions = @job.get_primary_conditions()
      @smart_conditions = @job.get_smart_conditions()

      res = {}
      res = res.merge(Conditions::THRESHOLDS_CONDITIONS)
      res = res.merge(Conditions::PRIMARY_CONDITIONS)
      res = res.merge(Conditions::SMART_CONDITIONS)
      @condition_descriptions = res

      cpu_user = FloatDatum.where(job_id: @job.id, name: "cpu_user").take
      @no_data = cpu_user.nil? || cpu_user.value.nil?
    end
  end
end
