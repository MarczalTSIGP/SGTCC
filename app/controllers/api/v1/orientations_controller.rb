module Api
  module V1
    class OrientationsController < Api::V1::ApiController
      def approved
        @orientations = Orientation.approved
        render json: OrientationsApprovedSerializer.new(@orientations)
      end

      def approved_tcc_one
        @orientations = Orientation.approved_tcc_one
        render json: OrientationsApprovedTCCOneSerializer.new(@orientations)
      end

      def in_tcc_one
        @orientations = Orientation.in_tcc_one
        render json: OrientationsInTCCOneSerializer.new(@orientations)
      end
    end
  end
end
