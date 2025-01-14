# == Schema Information
#
# Table name: jobstat_digest_float_data
#
#  id         :integer          not null, primary key
#  name       :string
#  time       :datetime
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :integer
#
# Indexes
#
#  index_jobstat_digest_float_data_on_job_id  (job_id)
#

module Jobstat
  class DigestFloatDatum < ActiveRecord::Base

    has_paper_trail

  end
end
