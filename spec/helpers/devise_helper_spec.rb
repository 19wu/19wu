require File.expand_path('../../spec_helper', __FILE__)

describe DeviseHelper do
  describe '#render_password_label_with_forget_link' do
    let(:object) { build :user }
    subject { helper.render_password_label_with_forget_link(object) }

    it { should have_selector('small > a') }
    it { should have_content(object.class.human_attribute_name(:password)) }
    it { should have_content(t('links.forget_pass')) }
  end
end
