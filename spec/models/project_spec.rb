# frozen_string_literal: true

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:slack_workspace) }
    it { should have_many(:developers) }
  end
end
