require 'active_record_helper'

require 'models/user'
require 'models/group'
require 'models/permission'

describe User do

  describe "associations" do
    it "should have many groups" do
      expect(described_class.reflect_on_association(:groups).macro).
        to eq(:has_and_belongs_to_many)
    end

    it "should have many permissions" do
      expect(described_class.reflect_on_association(:permissions).macro).
        to eq(:has_and_belongs_to_many)
    end
  end

  describe "validations" do
    let(:user) { User.new(username: 'username', account_number: '100',
                              enabled: true, email: 'user@email.com') }

    it { expect(user).to validate_presence_of(:username) }
    it { expect(user).to validate_presence_of(:account_number) }
    it { expect(user).to validate_presence_of(:email) }

    it { expect(user).to validate_uniqueness_of(:username) }
    it { expect(user).to validate_uniqueness_of(:account_number) }
    it { expect(user).to validate_uniqueness_of(:email) }
  end

  describe "assocation extensions" do
    let(:user) { User.create!(username: 'username', account_number: '100',
                              enabled: true, email: 'user@email.com') }

    context "#groups" do
      describe "<<" do
        it "will skip duplicate group additions" do
          group1 = Group.new(name: 'admin')
          group2 = Group.new(name: 'super_admin')

          user.groups << group1
          expect(user.groups.size).to be(1)
          user.groups << [group1, group2]
          expect(user.groups.size).to be(2)
          expect(user.groups).to match([group1, group2])
        end
      end
    end

    context "#permissions" do
      let(:permission1) { Permission.new(name: 'create_submission_batch') }
      let(:permission2) { Permission.new(name: 'update_submission_batch') }

      describe "<<" do
        it "will skip duplicate permission additions" do
          user.permissions << permission1
          expect(user.permissions.size).to be(1)
          user.permissions << [permission1, permission2]
          expect(user.permissions.size).to be(2)
          expect(user.permissions).to match([permission1, permission2])
        end
      end

      describe "names" do
        it "returns all the names of the assigned permissions" do
          user.permissions << [permission1, permission2]

          expect(user.permissions.names).to match(
            ['create_submission_batch', 'update_submission_batch'])
        end
      end
    end
  end

  describe ".for_account_number" do
    context "when the user is enabled" do
      before(:example) do
        User.create!(username: 'username', account_number: '100', 
                     enabled: true, email: 'user@email.com')
      end

      it "returns the enabled user" do
        user = User.for_account_number('100')
        expect(user).to_not be_nil
        expect(user.account_number).to eql('100')
      end

      it "returns nil when finding a disabled user" do
        user = User.for_account_number('100', false)
        expect(user).to be_nil
      end
    end

    context "when the user is disabled" do
      before(:example) do
        User.create!(username: 'username', account_number: '100', 
                     enabled: false, email: 'user@email.com')
      end

      it "returns the disabled user" do
        user = User.for_account_number('100', false)
        expect(user).to_not be_nil
        expect(user.account_number).to eql('100')
      end

      it "returns nil when finding an enabled user" do
        user = User.for_account_number('100', true)
        expect(user).to be_nil
      end
    end

    it "returns nil when account_number cannot be found" do
      User.create!(username: 'username', account_number: '10', email: 'user@email.com')

      user = User.for_account_number('100')
      expect(user).to be_nil
    end
  end

  describe "#has_permission?" do
    let(:user) { User.create!(username: 'username', account_number: '100',
                              enabled: false, email: 'user@email.com') }
    let(:permission1) { Permission.new(name: 'create_submission_batch') }
    let(:permission2) { Permission.new(name: 'update_submission_batch') }

    before do
      user.permissions << [permission1, permission2]
    end

    it "returns true if the user has the specified permission" do
      expect(user.has_permission?(permission2.name)).to be(true)
      expect(user.has_permission?(permission2.name.to_sym)).to be(true)
    end

    it "returns false if the user does not have the specified permission" do
      expect(user.has_permission?('some_permission')).to be(false)
    end
  end
end
