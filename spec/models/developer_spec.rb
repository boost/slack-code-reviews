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
    let!(:active_developers) { create_list(:developer, 3) }
    let!(:away_developers)   { create_list(:developer, 2, :away) }

    it 'returns all of the developers who are currently away' do
      expect(described_class.away.to_a).to eq away_developers
    end

    it 'does not return developers who are active' do
      expect(described_class.away.to_a).not_to eq active_developers
    end
  end

  describe '#status' do
    let(:away_developer)   { create(:developer, :away) }
    let(:active_developer) { create(:developer) }

    it 'returns away if the developer is away' do
      expect(away_developer.status).to eq 'away'
    end

    it 'returns available if the developer is available' do
      expect(active_developer.status).to eq 'available'
    end
  end
end
