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

    it 'returns all approved orientations in json format' do # rubocop:disable RSpec/MultipleExpectations
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
end
