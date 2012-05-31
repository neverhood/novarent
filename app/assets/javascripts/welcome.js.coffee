# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
    if document.body.id == 'welcome'

        $('div#special-offers').carousel(interval: 5000)

        $.datepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $.timepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(stepMinute: 10)

        $('input#rent_request_receipt_location, input#rent_request_drop_off_location').autocomplete(source: $.api.locations[ $.api.locale ], minLength: 0)

        $('input#rent_request_drop_off_at_receipt').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_confirm_drop_off_location').prop('checked', false).parents('div.control-group').slideToggle()

        $('input#rent_request_confirm_drop_off_location').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_drop_off_at_receipt').prop('checked', false).parents('div.control-group').slideToggle()

        $('span#receipt-suggestion').click ->
            input = $('input#rent_request_receipt_location')
            if input.autocomplete('widget').is ':visible'
                input.autocomplete 'close'
            else
                $('input#rent_request_receipt_location').autocomplete('search', '').focus()


        $('span#drop-off-suggestion').click ->
            input = $('input#rent_request_drop_off_location')
            if input.autocomplete('widget').is ':visible'
                input.autocomplete 'close'
            else
                $('input#rent_request_drop_off_location').autocomplete('search', '').focus()


