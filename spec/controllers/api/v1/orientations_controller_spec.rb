require 'rails_helper'

describe 'ApiV1OrientationsController', type: :request do
  context 'when approved' do
    let!(:orientations) { create_list(:orientation_tcc_two_approved, 2) }

    before do
      get api_v1_orientations_approved_path
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all approved orientations in json format' do
      resp = response.parsed_body['data']

      orientations.each_with_index do |orientation, index|
        academic = orientation.academic
        data = resp[index]['attributes']

        expect(data['academic']['name']).to eq academic.name

        expect(data['supervisors']['size']).to eq orientation.supervisors.size
        supervisors_name = orientation.supervisors.map(&:name_with_scholarity).join(', ')
        expect(data['supervisors']['names']).to eq supervisors_name

        expect(data['title']).to eq orientation.final_monograph.title
        expect(data['summary']).to eq orientation.final_monograph.summary
        date = orientation.examination_boards.find_by(identifier: :monograph,
                                                      situation: :approved).date
        expect(data['approved_date']).to eq(I18n.l(date, format: :long))

        expect(data['documents'][0]['name']).to eql('Monografia')
        expect(data['documents'][0]['url']).to eql orientation.final_monograph.pdf.url
      end
    end
  end

  context 'when approved in tcc one' do
    let!(:orientations) { create_list(:orientation_tcc_one_approved, 2) }

    before do
      get api_v1_orientations_approved_tcc_one_path
    end

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns all approved tcc one orientations in json format' do
      resp = response.parsed_body['data']

      orientations.each_with_index do |orientation, index|
        academic = orientation.academic
        data = resp[index]['attributes']

        expect(data['academic']['name']).to eq academic.name

        expect(data['supervisors']['size']).to eq orientation.supervisors.size
        supervisors_name = orientation.supervisors.map(&:name_with_scholarity).join(', ')
        expect(data['supervisors']['names']).to eq supervisors_name

        expect(data['title']).to eq orientation.final_project.title
        expect(data['summary']).to eq orientation.final_project.summary
        date = orientation.examination_boards.find_by(identifier: :project,
                                                      situation: :approved).date
        expect(data['approved_date']).to eq(I18n.l(date, format: :long))

        expect(data['documents'][0]['name']).to eql('Projeto')
        expect(data['documents'][0]['url']).to eql orientation.final_project.pdf.url
      end
    end
  end

  context 'when in tcc one' do
    let!(:orientations) { create_list(:orientation_tcc_one, 2) }

    it 'returns status ok' do
      get api_v1_orientations_in_tcc_one_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all orientations in tcc one at json format' do
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

    it 'returns all orientations in tcc one at json format with proposal' do
      orientation = orientations.first
      calendar = orientation.calendars.first
      academic = orientation.academic

      activity = create(:activity, calendar: calendar, identifier: :proposal, final_version: true)
      create(:academic_activity, activity: activity, academic: academic)
      create(:examination_board, orientation: orientation, identifier: :proposal,
                                 situation: :approved)

      get api_v1_orientations_in_tcc_one_path
      resp = response.parsed_body['data']

      data = resp[1]['attributes']

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
