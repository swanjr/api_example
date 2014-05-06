Given(/^a log event$/) do
  @payload = {
      'NonsensitiveData'=> 'ok'
  }
end

Given(/^password fields are present$/) do
  @payload['Password'] = '12345qwerty'
  @payload['GrandParentWithPassword'] = {
      'Parent' => {
          'MyPassword' =>'secret'
      }
  }
  @log_event = Getty::Instrumentation::LogEvent.new('password_event', nil, @payload)
  @log_event.add_data({'added_password' => 'anotherpw' })
end

Given(/^token fields are present$/) do
  @payload['Token'] = '12345qwerty'
  @payload['GrandParentWithToken'] = {
      'Parent' => {
          'MyToken' =>'token23456'
      }
  }
  @log_event = Getty::Instrumentation::LogEvent.new('token_event', nil, @payload)
  @log_event.add_data({'added_token' => 'anothertoken'})
end

Given(/^credit card fields are present$/) do
  @payload['CardNumber'] = 371449635398431
  @payload['GrandParentWithCardNumber'] = {
      'Parent'=> {
          'MyCardNumber'=> '5105105105105100'
      }
  }
  @log_event = Getty::Instrumentation::LogEvent.new('token_event', nil, @payload)
  @log_event.add_data({'added_card_number' => '6011111111111117'})
end

Given(/^CVV fields are present$/) do
  @payload['CVV2'] = 123
  @payload['GrandParentWithCVV2'] = {
      'Parent'=> {
          'MyCVV2'=> '9876'
      }
  }
  @log_event = Getty::Instrumentation::LogEvent.new('CVV2_event', nil, @payload)
  @log_event.add_data({'added_CVV2' => '456'})
end

When(/^it is written to the log$/) do
  @result = @log_event.log_data
end

Then(/^all password data should be sanitized$/) do
  @result['Password'].should == '**********'
  @result['GrandParentWithPassword']['Parent']['MyPassword'].should == '**********'
  @result['added_password'].should == '**********'
end

Then(/^all token data should be sanitized$/) do
  @result['Token'].should == '12345qw*******************'
  @result['GrandParentWithToken']['Parent']['MyToken'].should == 'token23*******************'
  @result['added_token'].should == 'another*******************'
end

Then(/^all credit card numbers should be sanitized$/) do
  @result['CardNumber'].should == '***********8431'
  @result['GrandParentWithCardNumber']['Parent']['MyCardNumber'].should == '************5100'
  @result['added_card_number'].should == '************1117'
end

Then(/^nonsensitive data is unaffected$/) do
  @result['NonsensitiveData'].should == 'ok'
end

Then(/^all CVV numbers should be sanitized$/) do
  @result['CVV2'].should == '***'
  @result['GrandParentWithCVV2']['Parent']['MyCVV2'].should == '****'
  @result['added_CVV2'].should == '***'
end