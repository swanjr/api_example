# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission_batch, aliases: [:getty_creative_video_batch] do
    owner_id 1
    name 'My Submission Batch'
    allowed_contribution_type Contribution::TYPES[:getty_creative_video]
  end
end
