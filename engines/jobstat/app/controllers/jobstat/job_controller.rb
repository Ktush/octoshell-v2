require_dependency "jobstat/application_controller"

module Jobstat
  class JobController < ApplicationController
    include JobHelper

    def graph_data_multi(dataset_a, dataset_b)
      tmp_hash = {}

      dataset_b.each do |entry|
        tmp_hash[entry.time] = entry.value
      end

      result = []

      dataset_a.each do |entry|
	      result.push([entry.time.to_i, entry.value, tmp_hash[entry.time]])
      end

      result
    end

    def graph_data_single dataset
      result = []

      dataset.each do |entry|
	      result.push([entry.time.to_i, entry.value])
      end

      result
    end

    def show
      @job = Job.find(params["id"])

      @job_perf = @job.get_performance
      @ranking = @job.get_ranking
      @current_user = current_user

      @cpu_digest_data = graph_data_single(DigestFloatDatum.where(job_id: @job.id, name: "cpu_user").order(:time).all)
      @gpu_digest_data = graph_data_single(DigestFloatDatum.where(job_id: @job.id, name: "gpu_load").order(:time).all)
      @loadavg_digest_data = graph_data_single(DigestFloatDatum.where(job_id: @job.id, name: "loadavg").order(:time).all)
      @ipc_digest_data = graph_data_single(DigestFloatDatum.where(job_id: @job.id, name: "ipc").order(:time).all)

      rcv_mpi = DigestFloatDatum.where(job_id: @job.id, name: "ib_rcv_data_mpi").order(:time).all
      xmit_mpi = DigestFloatDatum.where(job_id: @job.id, name: "ib_xmit_data_mpi").order(:time).all

      rcv_fs = DigestFloatDatum.where(job_id: @job.id, name: "ib_rcv_data_fs").order(:time).all
      xmit_fs = DigestFloatDatum.where(job_id: @job.id, name: "ib_xmit_data_fs").order(:time).all

      @mpi_digest_data = graph_data_multi(rcv_mpi, xmit_mpi)
      @fs_digest_data = graph_data_multi(rcv_fs, xmit_fs)

      cpu_user = FloatDatum.where(job_id: @job.id, name: "cpu_user").take

      if cpu_user.nil? || cpu_user.value.nil?
        render :show_no_data
      end
    end

    def show_direct
      job = Job.where(drms_job_id: params["drms_job_id"], cluster: params["cluster"]).take
      redirect_to :action => 'show', :id => job.id
    end
  end
end
