# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
    $('div#special-offers').carousel(interval: 5000)

    $.datepicker.setDefaults( $.datepicker.regional[ "ru" ] )
    $.timepicker.setDefaults( $.datepicker.regional[ "ru" ] )
    $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(stepMinute: 10)
