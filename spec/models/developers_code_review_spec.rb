# frozen_string_literal: true

RSpec.describe DevelopersCodeReview, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:developer) }
    it { is_expected.to belong_to(:code_review) }
  end
end
