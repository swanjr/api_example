require 'active_record_helper'

require 'models/user'
require 'models/permission'

require 'models/group'

describe Group do

  describe "associations" do
    it "should have many permissions" do
      expect(described_class.reflect_on_association(:permissions).macro).
        to eq(:has_and_belongs_to_many)
    end

    it "should have many users" do
      expect(described_class.reflect_on_association(:users).macro).
        to eq(:has_and_belongs_to_many)
    end
  end

  describe "validations" do
    let(:group) { Group.new(name: 'admin') }

    it { expect(group).to validate_presence_of(:name) }
    it { expect(group).to validate_uniqueness_of(:name) }
  end

  describe "assocation extensions" do
    let(:group) { Group.create!(name: 'admin') }

    context "#permissions" do
      describe "<<" do
        it "will skip duplicate permission additions" do
          permission1 = Permission.new(name: 'create_submission_batch')
          permission2 = Permission.new(name: 'update_submission_batch')

          group.permissions << permission1
          expect(group.permissions.size).to be(1)
          group.permissions << [permission1, permission2]
          expect(group.permissions.size).to be(2)
          expect(group.permissions).to match([permission1, permission2])
        end
      end
    end

    context "#users" do
      describe "<<" do
        it "will skip duplicate user additions" do
          user1 = User.new(username: 'username1', account_number: '100',
                           enabled: true, email: 'user1@email.com')
          user2 = User.new(username: 'username2', account_number: '101',
                           enabled: true, email: 'user2@email.com')

          group.users << user1
          expect(group.users.size).to be(1)
          group.users << [user1, user2]
          expect(group.users.size).to be(2)
          expect(group.users).to match([user1, user2])
        end
      end
    end
  end

  describe "#add_user" do
    let(:group) { Group.create!(name: 'admin') }
    let(:user) { User.create!(username: 'username', account_number: '100',
               enabled: true, email: 'user@email.com') }

    it "adds the group's permissions to the user's permissions" do
      group.permissions << Permission.new(name: 'create_submission_batch')
      expect(group.permissions).to_not be_empty

      group.add_user(user)
      expect(user.permissions).to match(group.permissions)
    end

    it "associates the user with the group" do
      group.add_user(user)
      expect(group.users).to include(user)
    end
  end

  describe "#remove_user" do
    let(:group) { Group.create!(name: 'admin') }
    let(:user) { User.create!(username: 'username', account_number: '100',
               enabled: true, email: 'user@email.com') }

    it "removes the group's permissions from the user's permissions" do
      create_permission = Permission.new(name: 'create_submission_batch')
      update_permission = Permission.new(name: 'update_submission_batch')

      group.permissions << [create_permission, update_permission]
      user.permissions << [create_permission, update_permission]
      expect(group.permissions).to match(user.permissions)

      group.remove_user(user)
      expect(user.permissions).to be_empty
    end

    it "does not remove permissions that are still associated through other groups" do
      group2 = Group.create!(name: "super_admin")

      create_permission = Permission.new(name: 'create_submission_batch')
      update_permission = Permission.new(name: 'update_submission_batch')

      group.permissions << [create_permission, update_permission]
      group2.permissions << create_permission
      user.permissions << [create_permission, update_permission]

      user.groups << [group, group2]
      expect(group.permissions).to match(user.permissions)

      group.remove_user(user)
      expect(user.permissions).to match([create_permission])
    end

    it "removes the user from the group" do
      group2 = Group.create!(name: "super_admin")
      user.groups << [group, group2]
      expect(group.users).to_not be_empty

      group.remove_user(user)

      expect(user.groups).to match([group2])
      expect(group.users).to be_empty
    end
  end
end
