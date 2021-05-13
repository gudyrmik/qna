require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question, Answer, Comment }
    it { is_expected.to_not be_able_to :like, Question, Answer }
    it { is_expected.to_not be_able_to :mark_as_best, Answer }
    it { is_expected.to_not be_able_to :create_comment, Question, Answer }
    it { is_expected.to_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let!(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:another) { create(:user) }
    let(:self_question) { create(:question, user: user) }
    let(:self_answer) { create(:answer, user: user) }
    let(:self_comment) { create(:comment, user: user, commentable: self_answer) }

    let(:other_question) { create(:question, user: another) }
    let(:other_answer) { create(:answer, user: another) }
    let(:other_comment) { create(:comment, user: another, commentable: self_answer) }

    it { is_expected.to_not be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to :create, Answer, Question, Comment }
    it { is_expected.to be_able_to [:update, :destroy], self_question, self_answer, self_comment }
    it { is_expected.to_not be_able_to [:update, :destroy], other_question, other_answer, other_comment }
    it { is_expected.to be_able_to :create_comment, self_answer, self_question, other_question, other_answer }
  end
end

