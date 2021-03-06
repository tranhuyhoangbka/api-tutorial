class Api::V1::SessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]

    if (user = User.find_by_email(user_email)) && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: {errors: "Invalid email or password"}, status: 422
    end
  end

  def destroy
    user = User.find_by_auth_token params[:id]
    user.generate_authentication_token!
    user.save
    head 204
  end
end
