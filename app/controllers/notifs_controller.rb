class NotifsController < ApplicationController

  def seen
    @notif = Notif.find(params[:id])
    @notif.update(seen: true)

    redirect_to review_policies_path
  end
end
