module NotifsHelper
  # translate a given message
  # new_status --> NUMBER is now STATUS
  # unrecognized --> Have a Good Day, Sir!
  def translate_message(t, p)
    case t
    when "new_status"
      return "#{p.number} is now #{p.status}"
    else
      return "Have a Good Day, Sir!"
    end
  end
end
