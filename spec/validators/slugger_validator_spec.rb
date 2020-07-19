require 'rails_helper'

module Test
  SluggerValidatable = Struct.new(:slug) do
    include ActiveModel::Validations

    validates :slug, slugger: true
  end
end

RSpec.describe SluggerValidator, type: :model do
  subject(:model) { Test::SluggerValidatable.new 'xxtestxx' }

  it { is_expected.to be_valid }

  it 'is invalid' do
    model.slug = 'xx 2x/'
    model.valid?
    expect(model.errors[:slug]).to match_array(I18n.t('errors.messages.slugger_invalid'))
  end
end
