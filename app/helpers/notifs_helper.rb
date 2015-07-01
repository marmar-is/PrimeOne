module NotifsHelper
  # translate a given message
  # NUMBER --> policy's number
  # STATUS --> policy's status
  def translate_message(t, p)
    case t
    when "new_status"
      return "#{p.number} is now #{p.status}"
    else
      return "Have a Good Day, Sir!"
    end
  end
end
