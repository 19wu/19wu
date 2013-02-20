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
        its(:valid?) { should be_false }
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
end
