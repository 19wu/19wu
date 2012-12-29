require 'spec_helper'

describe User do
  let(:user) { build :user }

  it "passes validation with all valid informations" do
    expect(build :user).to be_valid
  end

  context "fails validation" do
    it "with a blank login" do
      user.login = ''
      expect(user.save).to be_false
    end

    it "with a duplicated login" do
      create :user, :login => user.login

      expect(user.save).to be_false
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
end
