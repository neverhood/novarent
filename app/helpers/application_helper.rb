module ApplicationHelper

  def page_header(text = t('.header'))
    "<div class='page-header'> <h2>#{ text }</h2> </div>".html_safe
  end

  def plus_sign
    "<i class='icon-plus-sign'></i>".html_safe
  end

end
