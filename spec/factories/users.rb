# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :user do
    sequence(:username){ |n| "#{Faker::Internet.user_name}#{n}" }
    account_id { Faker::Number.number(7) }
    email { Faker::Internet.email }

    #factory :super_admin do
      #after(:create) {|user| user.add_role(:super_admin)}
    #end

    #factory :admin do
      #after(:create) {|user| user.add_role(:admin)}
    #end

    #factory :uploader do
      #after(:create) do |user|
        #user.add_role(:uploader)
        #user.add_role(:fake_role)
      #end
    #end

    #factory :reviewer do
      #after(:create) {|user| user.add_role(:reviewer)}
    #end

  end

  factory :token_user, class: User do
    username 'matt@punchstock.com'
    account_id '4752939'
    email 'matt@punchstock.com'
  end

end
