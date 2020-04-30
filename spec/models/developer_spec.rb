# frozen_string_literal: true

RSpec.describe Developer, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:slack_workspace) }
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to have_many(:developers_code_reviews) }
    it { is_expected.to have_many(:code_reviews).through(:developers_code_reviews) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slack_id) }
  end

  describe '#away' do
    let!(:active_developers) { create_list(:developer, 3)     }
    let!(:away_developers)   { create_list(:developer, 2, :away) }

    it 'returns all of the developers who are currently away' do
      expect(Developer.away.to_a).to eq away_developers
    end
  end
end
