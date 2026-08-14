module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  # Add cookies to browser for persistence
  private

  def authenticate
    if authenticated_player = Player.find_by(token: cookies.encrypted[:auth_token])
      Current.player = authenticated_player
    else
      redirect_to root_path, alert: "Invalid code"
    end
  end
end
