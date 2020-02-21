# frozen_string_literal: true

RSpec.describe CodeReview, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:slack_workspace) }
    it { is_expected.to have_many(:developers_code_reviews) }
    it { is_expected.to have_many(:developers).through(:developers_code_reviews) }
  end
end
