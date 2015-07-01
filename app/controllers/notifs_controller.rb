class NotifsController < ApplicationController

  def seen
    @notif = Notif.find(params[:id])
    @notif.update(seen: true)

    respond_to do |format|
      format.js
    end
    #redirect_to Policy_path(notif.policy)
  end
end
