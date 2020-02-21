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
end
