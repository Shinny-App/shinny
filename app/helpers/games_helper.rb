module GamesHelper
  def rsvp_status_class(response)
    case response
    when "yes" then "text-green-600"
    when "no" then "text-red-600"
    when "maybe" then "text-yellow-600"
    else "text-gray-400"
    end
  end

  def rsvp_status_label(response)
    case response
    when "yes" then "I'm in"
    when "no" then "Can't make it"
    when "maybe" then "Maybe"
    else "Not responded"
    end
  end
end
