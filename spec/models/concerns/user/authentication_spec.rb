require 'spec_helper'
require 'factories/users'

describe Concerns::User::Authentication do

  describe '#command?' do
    it 'returns false when not command user' do
      user = build(:user, email: 'test@gimmecar.com')
      expect(user.command?).to eq(false)
    end

    it 'returns true when command user' do
      user = build(:user, email: 'samay@gimmecar.com')
      expect(user.command?).to eq(true)
    end
  end
end
