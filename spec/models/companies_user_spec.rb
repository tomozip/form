require 'spec_helper'

describe CompaniesUser do
  it 'has a vlid factory' do
    expect(build(:companies_user)).to be_valid
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
