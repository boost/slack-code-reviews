# frozen_string_literal: true

RSpec.describe CodeReview, type: :model do
  describe 'associations' do
    it { should belong_to(:slack_workspace) }
    it { should have_many(:developers_code_reviews) }
    it { should have_many(:developers).through(:developers_code_reviews) }
  end
end
