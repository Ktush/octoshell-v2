# == Schema Information
#
# Table name: pack_clustervers
#
#  id              :integer          not null, primary key
#  active          :boolean
#  path            :string
#  created_at      :datetime
#  updated_at      :datetime
#  core_cluster_id :integer
#  version_id      :integer
#
# Indexes
#
#  index_pack_clustervers_on_core_cluster_id  (core_cluster_id)
#  index_pack_clustervers_on_version_id       (version_id)
#

module Pack
  class Clusterver < ActiveRecord::Base

    has_paper_trail

    delegate :name,to: :core_cluster
    attr_accessor :stale_edit
    validate :stale_check

    def stale_check
      if stale_edit
        errors.add(:action,I18n.t("stale_error_nested"))
      end
    end
    validates :core_cluster,:version, presence: true
    validates_uniqueness_of :version_id,:scope => :core_cluster_id
    belongs_to :core_cluster,class_name: "Core::Cluster",inverse_of: :clustervers
    belongs_to :version,inverse_of: :clustervers

    def action
      return "_destroy" if marked_for_destruction?
      if active
        "active"
      else
        "not_active"
      end
    end

    # def action=(arg)
    #   case arg
    #     when "active"
    #       active=true
    #     when "not_active"
    #      active=false
    #     when "_destroy"
    #       mark_for_destruction
    #     else
    #         raise "incorrect attribute in clustervers"
    #     end
    # end

     def get_color
      if active
        'green'
      else
        'red'
      end
    end
  end
end
