# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ->
    if document.body.id == 'rent-requests'
        if $('input#rent_request_confirm_drop_off_location').is ':checked'
            $('input#rent_request_drop_off_at_receipt').parents('div.control-group').hide()
            $('input#rent_request_drop_off_location').parents('div.control-group').hide()

        if $('input#rent_request_drop_off_at_receipt').is ':checked'
            $('input#rent_request_confirm_drop_off_location').parents('div.control-group').hide()
            $('input#rent_request_drop_off_location').parents('div.control-group').hide()

        $('input#rent_request_drop_off_at_receipt').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_confirm_drop_off_location').prop('checked', false).parents('div.control-group').slideToggle()

        $('input#rent_request_confirm_drop_off_location').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_drop_off_at_receipt').prop('checked', false).parents('div.control-group').slideToggle()
