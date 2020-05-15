# frozen_string_literal: true

RSpec.describe Slack::Action::AddCodeReview, type: :action do
  subject :add_code_review do
    described_class.new(
      slack_workspace,
      urls,
      requestor,
      given_reviewers,
      'CR78R22AH',
      'note'
    )
  end

  let!(:slack_workspace) { create(:slack_workspace) }
  let(:project)         { create(:project, slack_workspace: slack_workspace) }
  let(:requestor)       { create(:developer, project: project, slack_workspace: slack_workspace) }

  let(:urls) { [Url.new(url: 'https://github.com/boost/slack-code-reviews/pull/1')] }

  describe 'giving reviewers' do
    context 'when no reviewer is given' do
      let(:given_reviewers) { [] }

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change(CodeReview, :count).by(1)

        expect(CodeReview.last.urls.first).to eq(urls.first)
      end

      context 'when there is someone else in the queue on the project' do
        let! :queue do
          [
            create(:developer, slack_workspace: slack_workspace),
            create(:developer, project: project, slack_workspace: slack_workspace),
            create(:developer, project: project, slack_workspace: slack_workspace)
          ]
        end

        it 'creates a code review' do
          expect do
            add_code_review
          end.to change(CodeReview, :count).by(1)
        end

        it 'picks the first developer on the project in the queue' do
          add_code_review
          expect(CodeReview.last.developers).to include(queue.second)
        end

        it 'picks the first developer on the queue' do
          add_code_review
          expect(CodeReview.last.developers).to include(queue.first)
        end
      end

      context 'when there is no one else in the queue on the project' do
        let! :queue do
          create_list(:developer, 3, slack_workspace: slack_workspace)
        end

        it 'picks the first two developers in the queue' do
          add_code_review
          expect(CodeReview.last.developers.to_a).to eq(queue.first(2))
        end
      end

      context 'when there is no one else in the queue' do
        let(:queue) { [] }

        it 'creates a code review' do
          expect do
            add_code_review
          end.to change(CodeReview, :count).by(1)
        end
      end
    end

    context 'when given one reviewer' do
      let!(:given_reviewer) { create(:developer, name: '@gus') }
      let(:given_reviewers) { [given_reviewer] }

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change(CodeReview, :count).by(1)

        expect(CodeReview.last.urls).to eq(urls)
      end

      it 'assigns the matching developer as a reviewer' do
        add_code_review
        expect(CodeReview.last.developers).to include(given_reviewer)
      end

      context 'when the given reviewer is on the requestors project' do
        before do
          given_reviewer.update(project: requestor.project)
        end

        context 'when there is someone else in the queue' do
          let! :queue do
            [
              *create_list(:developer, 2, slack_workspace: slack_workspace),
              create(:developer, project: project, slack_workspace: slack_workspace)
            ]
          end

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change(CodeReview, :count).by(1)
          end

          it 'picks the next developer in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.first)
          end
        end

        context 'when there is no one else in the queue' do
          let(:queue) { [] }

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change(CodeReview, :count).by(1)
          end
        end
      end

      context 'when the given reviewer is not on the requestors project' do
        context 'when there is someone else in the queue on the project' do
          let! :queue do
            [
              create(:developer, slack_workspace: slack_workspace),
              create(:developer, project: project, slack_workspace: slack_workspace),
              create(:developer, project: project, slack_workspace: slack_workspace)
            ]
          end

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change(CodeReview, :count).by(1)
          end

          it 'picks the first developer on the project in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.second)
          end
        end

        context 'when there is no one else in the queue on the project' do
          let! :queue do
            create_list(:developer, 3, slack_workspace: slack_workspace)
          end

          it 'picks the first developer in the queue' do
            add_code_review
            expect(CodeReview.last.developers).to include(queue.first)
          end
        end

        context 'when there is no one else in the queue' do
          let(:queue) { [] }

          it 'creates a code review' do
            expect do
              add_code_review
            end.to change(CodeReview, :count).by(1)
          end
        end
      end
    end

    context 'when given two reviewers' do
      let!(:given_reviewers) do
        [create(:developer, name: '@gus'), create(:developer, name: '@paul')]
      end

      it 'creates a code review with the given url' do
        expect do
          add_code_review
        end.to change(CodeReview, :count).by(1)

        expect(CodeReview.last.urls).to eq(urls)
      end

      it 'assigns both matching developers as the reviewers' do
        add_code_review
        expect(CodeReview.last.developers.to_a).to eq(given_reviewers)
      end
    end
  end
end
