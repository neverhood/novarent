module RentRequestsHelper

  def babe_seats amount
    translation = ( amount == 1 ) ? t('rent_requests.show.babe_seat') : t('rent_requests.show.babe_seats')

    payment_entry translation, @rent_request.cost_of_babe_seats
  end

  def child_seats amount
    translation = ( amount == 1 ) ? t('rent_requests.show.child_seat') : t('rent_requests.show.child_seats')

    payment_entry translation, @rent_request.cost_of_child_seats
  end

  def payment_entry translation, value
    "<div> <strong> #{ translation }: </strong> <span class='money'> #{ value }$ </span> </div>".html_safe
  end

  def info_row translation, value
    "<div><strong> #{ translation }: </strong> #{ value }</div>".html_safe
  end

end
