# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
    if document.body.id == 'welcome'

        $.api.welcome =
            receiptLocation: $('input#rent_request_receipt_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffLocation: $('input#rent_request_drop_off_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAtReceipt: $('input#rent_request_drop_off_at_receipt')
            confirmDropOffLocation: $('input#rent_request_confirm_drop_off_location')
            receiptAt: $('input#rent_request_receipt_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAt: $('input#rent_request_drop_off_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            car: $('select#rent_request_car_id').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            name: $('input#rent_request_name').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            email: $('input#rent_request_email').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            phone: $('input#rent_request_phone')

        if $.api.action == 'index'
            if $.cookie('params')
                params = $.cookie('params').split(',')
                api = $.api.welcome

                api.receiptLocation.val params[0]
                api.dropOffLocation.val params[1]
                api.dropOffAtReceipt.prop('checked', params[2] == 'true')
                api.confirmDropOffLocation.prop('checked', params[3] == 'true')
                api.receiptAt.val params[4]
                api.dropOffAt.val params[5]
                api.car.val params[6]
                api.name.val params[7]
                api.email.val params[8]
                api.phone.val params[9]

                if params[2] == 'true'
                    api.confirmDropOffLocation.prop('checked', false).parents('div.control-group').hide()
                    api.dropOffLocation.parents('div.control-group').hide()
                if params[3] == 'true'
                    api.dropOffAtReceipt.prop('checked', false).parents('div.control-group').hide()
                    api.dropOffLocation.parents('div.control-group').hide()


            $(window).unload ->
                api = $.api.welcome

                values = [ api.receiptLocation.val(), api.dropOffLocation.val(), api.dropOffAtReceipt.is(':checked'), api.confirmDropOffLocation.is(':checked'),
                    api.receiptAt.val(), api.dropOffAt.val(), api.car.val(), api.name.val(), api.email.val(), api.phone.val() ]

                $.cookie('params', values.join(','))

        $('div#special-offers').carousel(interval: 5000)

        $.datepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $.timepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(stepMinute: 10, minDate: new Date)

        $('input#rent_request_receipt_location, input#rent_request_drop_off_location').autocomplete(
            source: $.api.locations[ $.api.locale ]
            minLength: 0
            select: (event, ui) ->
                $(this).parents('div.control-group').removeClass('error')
        )

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

        $('form#new-rent-request').submit ->
            fieldsWithErrors = []

            if $.api.welcome.receiptLocation.val().length == 0
                fieldsWithErrors.push $.api.welcome.receiptLocation.parents('div.control-group')

            if $.api.welcome.dropOffLocation.val().length == 0 and not $.api.welcome.dropOffAtReceipt.is(':checked') and not $.api.welcome.confirmDropOffLocation.is(':checked')
                fieldsWithErrors.push $.api.welcome.dropOffLocation.parents('div.control-group')

            if $.api.welcome.receiptAt.val().length == 0
                fieldsWithErrors.push $.api.welcome.receiptAt.parents('div.control-group')

            if $.api.welcome.dropOffAt.val().length == 0
                fieldsWithErrors.push $.api.welcome.dropOffAt.parents('div.control-group')

            if $.api.welcome.car.val().length == 0
                fieldsWithErrors.push $.api.welcome.car.parents('div.control-group')

            if $.api.welcome.name.val().length == 0
                fieldsWithErrors.push $.api.welcome.name.parents('div.control-group')

            if $.api.welcome.email.val().length == 0 || ! validEmail( $.api.welcome.email.val() )
                fieldsWithErrors.push $.api.welcome.email.parents('div.control-group')

            if $.api.welcome.dropOffAt.datepicker('getDate') <= $.api.welcome.receiptAt.datepicker('getDate')
                fieldsWithErrors.push $.api.welcome.dropOffAt.parents('div.control-group')
                fieldsWithErrors.push $.api.welcome.receiptAt.parents('div.control-group')

            if fieldsWithErrors.length > 0
                $.each fieldsWithErrors, ->
                    this.addClass('error').removeClass('success')

                false


