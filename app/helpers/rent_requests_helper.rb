module RentRequestsHelper

  def babe_seats amount
    translation = ( amount == 1 ) ? t('rent_requests.show.babe_seat') : t('rent_requests.show.babe_seats')

    "<div>
       <strong> #{ translation } <span class='label label-info'>#{amount}</span>: </strong> <span> #{ @rent_request.cost_of_babe_seats }$ </span> #{ plus_sign }
     </div>".html_safe
  end

  def child_seats amount
    translation = ( amount == 1 ) ? t('rent_requests.show.child_seat') : t('rent_requests.show.child_seats')

    "<div>
       <strong> #{ translation } <span class='label label-info'>#{amount}</span>: </strong> <span> #{ @rent_request.cost_of_child_seats }$ </span> #{ plus_sign }
     </div>".html_safe
  end

end
