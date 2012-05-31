# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ->
    if document.body.id == 'rent-requests'

        $.api.rentRequests =
            receiptLocation: $('input#rent_request_receipt_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffLocation: $('input#rent_request_drop_off_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAtReceipt: $('input#rent_request_drop_off_at_receipt')
            confirmDropOffLocation: $('input#rent_request_confirm_drop_off_location')
            receiptAt: $('input#rent_request_receipt_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAt: $('input#rent_request_drop_off_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            name: $('input#rent_request_name').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            email: $('input#rent_request_email').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            phone: $('input#rent_request_phone')


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

        $.datepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $.timepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(stepMinute: 10, minDate: new Date)

        $('input#rent_request_receipt_location, input#rent_request_drop_off_location').autocomplete(
            source: $.api.locations[ $.api.locale ]
            minLength: 0
            select: (event, ui) ->
                $(this).parents('div.control-group').removeClass('error')
        )

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


        $('form#new-rent-request').submit ->
            fieldsWithErrors = []
            errorsMessage = if $.api.locale == 'ru' then 'Пожалуйста, исправьте возникшие ошибки' else 'Errors occred, please fix these and resubmit the form'

            if $.api.rentRequests.receiptLocation.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.receiptLocation.parents('div.control-group')

            if $.api.rentRequests.dropOffLocation.val().length == 0 and not $.api.rentRequests.dropOffAtReceipt.is(':checked') and not $.api.rentRequests.confirmDropOffLocation.is(':checked')
                fieldsWithErrors.push $.api.rentRequests.dropOffLocation.parents('div.control-group')

            if $.api.rentRequests.receiptAt.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.receiptAt.parents('div.control-group')

            if $.api.rentRequests.dropOffAt.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.dropOffAt.parents('div.control-group')

            if $.api.rentRequests.name.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.name.parents('div.control-group')

            if $.api.rentRequests.email.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.email.parents('div.control-group')

            if fieldsWithErrors.length > 0
                $.each fieldsWithErrors, ->
                    this.addClass('error').removeClass('success')

                if $(this).find('div.alert-error').length == 0
                    $(this).append("<div class='alert alert-error margin-top'>" + errorsMessage + "</div>")


                false


