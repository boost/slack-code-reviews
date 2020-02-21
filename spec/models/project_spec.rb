# frozen_string_literal: true

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:slack_workspace) }
    it { is_expected.to have_many(:developers) }
  end
end
