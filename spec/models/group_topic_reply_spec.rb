require 'spec_helper'

describe GroupTopicReply do
  let(:topic) { create(:group_topic, :with_group) }

  # https://github.com/19wu/19wu/issues/421
  describe '#topic' do
    it 'returns topic the reply belongs to' do
      reply = build(:group_topic_reply, :group_topic_id => topic.id)
      expect(reply.topic).to be_a_kind_of(GroupTopic)
    end
  end
end
