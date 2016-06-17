require_relative 'web_helper'

feature 'User sign in' do
  	 let(:user) do
  	   User.create(email: 'bob@bob.com',
  	   	           password: 'password',
  	   	           password_confirmation: 'password')
  	  end

   scenario 'Signs in with the correct credentials' do
   	sign_in(email: user.email, password: user.password)
   	expect(page).to have_content "Welcome, #{user.email}"
  end

 end