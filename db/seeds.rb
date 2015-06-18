# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Role.create!([
  {name: 'super_admin'},
  {name: 'admin'},
  {name: 'getty_creative_video_uploader'},
  {name: 'getty_editorial_video_uploader'},
  {name: 'istock_creative_video_uploader'},
  {name: 'getty_editorial_still_uploader'},
  {name: 'needs_getty_creative_video_review'},
  {name: 'needs_getty_editorial_video_review'},
  {name: 'needs_getty_editorial_still_review'},
  {name: 'needs_istock_creative_video_review'},
  {name: 'getty_creative_video_reviewer'},
  {name: 'getty_editorial_video_reviewer'},
  {name: 'istock_creative_video_reviewer'},
  {name: 'getty_editorial_still_reviewer'}
])

