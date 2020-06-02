class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create unless Rails.env.production?

  def create
    byebug
    @islander = Islander.find_by(email: authorized_email)
    unless @islander
      redirect_to_auth(notice: "Sorry, we're not accepting new patients") # the notice doesn't work
      return
    end
    self.acting_islander = @islander
    redirect_to "/"
  end

  def delete
    self.clear_acting_islander
    redirect_to "/"
  end

  protected

  def authorized_email
    request.env.dig("omniauth.auth", :info, :email)  # well, it works for "developer"
  end
end
