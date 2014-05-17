#require 'lite_spec_helper'

#require 'esp/role/authorized_user'
#require 'models/user'

#describe Role::AuthorizedUser do
  #let(:authorized_user) { described_class.new(User.new(:username => 'original_username')) }

  #describe '#override_user' do
    #before(:each) do
      #allow(authorized_user).to receive(:save!)
    #end

    #it 'changes the username if it does not match the authorized_username parameter' do
      #authorized_user.override_username('new_username')
      #expect(authorized_user.username).to eq('new_username')
    #end

    #it 'does not change the username if the authorized_username parameter is blank' do
      #authorized_user.override_username(' ')
      #expect(authorized_user.username).to eq('original_username')
    #end

    #it 'saves the username change if it is updated' do
      #expect(authorized_user).to receive(:save!)
      #authorized_user.override_username('new_username')
    #end
  #end

#end
