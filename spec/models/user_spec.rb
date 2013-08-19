# encoding: utf-8
require 'spec_helper'

describe User do
  let(:user) { build :user }
  subject { user }

  it "passes validation with all valid informations" do
    expect(build :user).to be_valid
  end

  context "fails validation" do
    context "login" do
      context 'is blank' do
        before { user.login = '' }
        its(:valid?) { should be_false }
      end
      context 'is format invalid' do
        before { user.login = 'foo@bar' }
        it 'should show clear message' do
          subject.valid?.should be_false
          subject.errors[:login].should eql ['只允许大小写字母、数字和下划线']
        end
      end
      context 'is exploit_code' do
        before { user.login = "javascript:it();\nok" }
        it { should have(1).error_on(:login) }
      end
      context 'has been taken' do
        context 'by other user' do
          before { user.login = create(:user).login }
          its(:valid?) { should be_false }
        end
        context 'by other group' do
          before { user.login = create(:group).slug }
          its(:valid?) { should be_false }
        end
        context 'by routes' do
          before { user.login = 'photos' }
          its(:valid?) { should be_false }
        end
      end
    end

    it "with a blank email" do
      user.email = ''
      expect(user.save).to be_false
    end

    it "with an invalid email" do
      user.email = '19wuat19wudotorg'
      expect(user.save).to be_false
    end

    it "with a duplicated email" do
      create :user, :email => user.email

      expect(user.save).to be_false
    end

    it "with a password < 6 chars" do
      user.password = 'a2c4e'
      expect(user.save).to be_false
    end
  end

  describe '#profile' do
    context 'with profile' do
      let(:profile) { build :profile }
      let(:user) { build :user, :profile => profile }
      its(:profile) { should == profile }
    end
    context 'without profile' do
      let(:user) { build :user, :profile => nil }
      its(:profile) { should be_a_kind_of(Profile) }
    end
  end

  describe '#send_reset_password_instructions' do # issue#287
    context 'user is waiting for invite' do
      let(:user) { User.invite! email: 'demo@19wu.com', skip_invitation: true }
      before { user.send_reset_password_instructions }
      it 'should get errors' do
        user.errors[:email].first.should eql '您正申请注册，请等待邀请邮件.'
      end
    end
  end

  describe 'devise mails', :delay => true do
    before { user.save }

    describe '#send_reset_password_instructions' do
      context 'when user is waiting for invitation' do
        before { user.stub(:invited_to_sign_up? => true) }
        it 'does not send asynchronously' do
          expect {
            user.send_reset_password_instructions
          }.to change{Delayed::Job.count}.by(0)
        end
      end
      context 'when user is not waiting for invitation' do
        before { user.stub(:invited_to_sign_up? => false) }
        it 'sends asynchronously' do
          expect {
            user.send_reset_password_instructions
          }.to change{Delayed::Job.count}.by(1)
        end
      end
    end
    describe '#send_confirmation_instructions' do
      it 'sends asynchronously' do
        expect {
          user.send_confirmation_instructions
        }.to change{Delayed::Job.count}.by(1)
      end
    end
    describe '#send_on_create_confirmation_instructions' do
      it 'sends asynchronously' do
        expect {
          user.send :send_on_create_confirmation_instructions
        }.to change{Delayed::Job.count}.by(1)
      end
    end
  end
end
