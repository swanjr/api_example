# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
super_admin = Group.where(name: 'super_admin').first_or_create!
admin = Group.where(name: 'admin').first_or_create!

gcv_uploader_nr = Group.where(name: 'getty_creative_video_uploader_no_review').first_or_create!
gev_uploader_nr = Group.where(name: 'getty_editorial_video_uploader_no_review').first_or_create!
ges_uploader_nr = Group.where(name: 'getty_editorial_still_uploader_no_review').first_or_create!
icv_uploader_nr = Group.where(name: 'istock_creative_video_uploader_no_review').first_or_create!

gcv_uploader_wr = Group.where(name: 'getty_creative_video_uploader_with_review').first_or_create!
gev_uploader_wr = Group.where(name: 'getty_editorial_video_uploader_with_review').first_or_create!
ges_uploader_wr = Group.where(name: 'getty_editorial_still_uploader_with_review').first_or_create!
icv_uploader_wr = Group.where(name: 'istock_creative_video_uploader_with_review').first_or_create!

gcv_reviewer = Group.where(name: 'getty_creative_video_reviewer').first_or_create!
gev_reviewer = Group.where(name: 'getty_editorial_video_reviewer').first_or_create!
ges_reviewer = Group.where(name: 'getty_editorial_still_reviewer').first_or_create!
icv_reviewer = Group.where(name: 'istock_creative_video_reviewer').first_or_create!
puts "Groups created"

create_submission_batch = Permission.where(name: 'create_submission_batch').first_or_create!
read_submission_batch = Permission.where(name: 'read_submission_batch').first_or_create!
update_submission_batch = Permission.where(name: 'update_submission_batch').first_or_create!
puts "Permissions created"

super_admin.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
admin.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]

gcv_uploader_nr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
gev_uploader_nr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
ges_uploader_nr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
icv_uploader_nr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]

gcv_uploader_wr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
gev_uploader_wr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
ges_uploader_wr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]
icv_uploader_wr.permissions << [create_submission_batch, read_submission_batch, update_submission_batch]

puts "Permissions assigned to groups"
