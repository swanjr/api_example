namespace :test do
  namespace :data do
    #desc 'Creates test data for development purposes'
    #task :submission_batches => :environment do
      #30.times do
        #type = Random.rand(30) % 2 == 0 ? 'creative' : 'editorial'
        #random_user = User.all.sample
        #submission = SubmissionBatch.create(:submission_name => Faker::Company.name, 
                                            #:submission_type => type, 
                                            #:created_by => random_user.username, 
                                            #:user_id => random_user.integration_id) do |sb|
          #sb.created_at = Random.rand(300) % 2 == 0 ? Time.now : 10.days.ago
        #end
        #puts "Adding submission number #{submission.id}"
          #Random.rand(10).times do
            #contribution = FactoryGirl.create("#{type}_video".to_sym, :submission_batch => submission)
            #if Random.rand(300) % 2 == 0
              #contribution.mark_as_ready_to_pickup
            #end
            #if Random.rand(300) % 2 == 0
              #contribution.submitted_at = Random.rand(300) % 2 == 0 ? Time.now : 1.day.ago
            #end
            #contribution.save
            #puts "Adding contribution #{contribution.id} with status of #{contribution.status}"
          #end
      #end
    #end

    #desc 'Creates job records'
    #task :jobs => :environment do
      #30.times do
        #puts "Adding job"
        #Job.create(jid: '1234567890', command_id: '0987654321abcd', class_name: 'PublishCommand', disabled: false)
      #end
    #end

    #desc 'Creates some custom templates'
    #task :templates => :environment do
      #User.all.each do |user|
        #2.times do
          #FactoryGirl.create(:creative_template, 
                             #:name => "creative - #{Faker::Company.catch_phrase}",
                             #:user_id => user.integration_id)
        #end
        #2.times do
          #FactoryGirl.create(:editorial_template, 
                             #:name => "editorial - #{Faker::Company.catch_phrase}",
                             #:user_id => user.integration_id)
        #end
      #end
    #end

    desc 'Create some users'
    task :users => :environment do
     sample_users =  [
       ['matt@punchstock.com', '4752939'],
       ['JReeder','246323'],
       ['AParkin','309178'],
       ['arobertson','515808'],
       ['EileenODonnell','742414'],
       ['myeung','749274'],
       ['Alwyng','858090'],
       ['sbrooksbank','1157039'],
       ['noctest','1604399'],
       ['lshoulders','1775920'],
       ['gi-rpepper','1783886'],
       ['piercegins','2389953'],
       ['jnamwen','2647858'],
       ['spreegurke', '4334193'],
       ['nzdollars','2935469']
     ]
     sample_users.each do |user|

       delete_user = User.find_by(:username => user[0])
       if delete_user.present?
         delete_user.destroy!
       end

       if user[0] == "nzdollars"
         # nzdollars is an iStock user
         new_user = User.create!(
           :username => user[0],
           :email => user[0],
           :istock_username => user[0],
           :istock_account_number => '123456',
           :account_number => user[1],
           :enabled => true)
       else
         new_user = User.create!(
           :username => user[0],
           :email => user[0],
           :account_number => user[1],
           :enabled => true)

         user = User.find_by(:username => new_user.username)

         if user.username == "matt@punchstock.com"
           Group.find_by(name: :super_admin).add_user(user)
           Group.find_by(name: :getty_creative_video_uploader_with_review).add_user(user)
           Group.find_by(name: :getty_editorial_video_uploader_with_review).add_user(user)
           Group.find_by(name: :getty_editorial_still_uploader_with_review).add_user(user)
         elsif user.username == "gtorn_is_god"
           # we need this user to exist without any roles for workflow tests
           user.permissions.delete_all
         else
           Group.find_by(name: :getty_creative_video_uploader_no_review).add_user(user)
           Group.find_by(name: :getty_editorial_video_uploader_no_review).add_user(user)
         end
       end
     end
    end
  end
end
