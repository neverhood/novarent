# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
    if document.body.id == 'welcome'

        $('div#special-offers').carousel(interval: 5000)

        $.datepicker.setDefaults( $.datepicker.regional[ "ru" ] )
        $.timepicker.setDefaults( $.datepicker.regional[ "ru" ] )
        $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(stepMinute: 10)

        $('input#rent_request_drop_off_at_receipt').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_confirm_drop_off_location').prop('checked', false).parents('div.control-group').slideToggle()

        $('input#rent_request_confirm_drop_off_location').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_drop_off_at_receipt').prop('checked', false).parents('div.control-group').slideToggle()

