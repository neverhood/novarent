module ApplicationHelper

  def page_header(text)
    "<div class='page-header'> <h2>#{ text }</h2> </div>".html_safe
  end

end
