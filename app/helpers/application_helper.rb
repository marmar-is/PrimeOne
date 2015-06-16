module ApplicationHelper
  # Set the html title from controller
  def title(page_title)
    base_title = "Prime One"
    if page_title.nil?
      base_title
    else
      # "#{base_title} | #{@title}"
      @title || base_title
    end
  end

end
