require 'rails_helper'

describe 'ApiV1OrientationsController', type: :request do
  context 'when in tcc one' do
    let!(:orientations) { create_list(:orientation_tcc_one, 2) }

    it 'returns status ok' do
      get api_v1_orientations_in_tcc_one_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all orientations in tcc one at json format' do # rubocop:disable RSpec/MultipleExpectations
      get api_v1_orientations_in_tcc_one_path
      resp = response.parsed_body['data']

      orientations.each_with_index do |orientation, index|
        academic = orientation.academic
        data = resp[index]['attributes']

        expect(data['academic']['name']).to eq academic.name

        expect(data['supervisors']['size']).to eq orientation.supervisors.size
        supervisors_name = orientation.supervisors.map(&:name_with_scholarity).join(', ')
        expect(data['supervisors']['names']).to eq supervisors_name

        expect(data['title']).to eq orientation.title
        expect(data['summary']).to eql('')
      end
    end

    it 'returns all orientations in tcc one at json format with proposal' do # rubocop:disable RSpec/MultipleExpectations
      orientation = orientations.first
      calendar = orientation.calendars.first
      academic = orientation.academic

      activity = create(:activity, calendar:, identifier: :proposal, final_version: true)
      create(:academic_activity, activity:, academic:)
      create(:examination_board, orientation:, identifier: :proposal,
                                 situation: :approved)

      get api_v1_orientations_in_tcc_one_path
      resp = response.parsed_body['data']

      response_orientation = resp.detect { |o| o['id'] == orientation.id.to_s }
      expect(response_orientation).to be_present
      data = response_orientation['attributes']

      expect(data['title']).to eql orientation.final_proposal.title
      expect(data['summary']).to eql orientation.final_proposal.summary

      date = orientation.examination_boards.find_by(identifier: :proposal,
                                                    situation: :approved).date
      expect(data['approved_date']).to eq(I18n.l(date, format: :long))

      expect(data['documents'][0]['name']).to eql('Proposta')
      expect(data['documents'][0]['url']).to eql orientation.final_proposal.pdf.url
    end
  end
end
