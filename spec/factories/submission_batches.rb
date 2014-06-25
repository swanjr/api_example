# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission_batch do
    owner_id 1
    name "My Submission Batch"
    media_type 'video'
    asset_family 'creative'
    istock true
  end
end
