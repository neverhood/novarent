# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

jQuery ->
    if document.body.id == 'rent-requests'

        $.api.rentRequests = api =
            receiptLocation: $('input#rent_request_receipt_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffLocation: $('input#rent_request_drop_off_location').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAtReceipt: $('input#rent_request_drop_off_at_receipt')
            confirmDropOffLocation: $('input#rent_request_confirm_drop_off_location')
            receiptAt: $('input#rent_request_receipt_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            dropOffAt: $('input#rent_request_drop_off_at').change -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            name: $('input#rent_request_name').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            email: $('input#rent_request_email').keyup -> $(this).parents('div.control-group').removeClass('error') if this.value.length
            phone: $('input#rent_request_phone')
            additionalServices:
                gps: $('#gps-cost-value')
                childSeat: $('#child-seat-cost-value')
                additionalDriver: $('#additional-driver-cost-value')
            rentPeriods:
                ru:
                    'unknown': 'Неизвестно'
                    'oneToTwo': '1-2 дня'
                    'threeToFive': '3-5 дней'
                    'sixToTwelve': '6-12 дней'
                    'thirteenToTwentyFour': '13-24 дня'
                    'month': 'месяц'
                en:
                    'unknown': 'Unknown'
                    'oneToTwo': '1-2 days'
                    'threeToFive': '3-5 days'
                    'sixToTwelve': '6-12 days'
                    'thirteenToTwentyFour': '13-24 days'
                    'month': 'month'

            rentDays: ->
                endRaw = $('#rent_request_drop_off_at').val().split(/\.| |:/)
                startRaw = $('#rent_request_receipt_at').val().split(/\.| |:/)
                start = new Date(startRaw[2], startRaw[1], startRaw[0], startRaw[3], startRaw[4])
                end = new Date(endRaw[2], endRaw[1], endRaw[0], endRaw[3], endRaw[4])

                Math.ceil( ( end - start ) / ( 1000*60*60*24 ) )

            rentPeriod: ->
                days = $.api.rentRequests.rentDays()

                if days <= 0
                    'unknown'
                else if days < 3
                    'oneToTwo'
                else if days < 6
                    'threeToFive'
                else if days < 13
                    'sixToTwelve'
                else if days < 25
                    'thirteenToTwentyFour'
                else
                    'month'

            displayTotal: ->
                $('#rent-request-cost-total').text( api.total() + '$' )
            recalculate: ->
                api.displayTotal()
                api.additionalServices.gps.text( api.gpsCost() + '$' )
                api.additionalServices.childSeat.text( api.childSeatCost()  + '$' )
                api.additionalServices.additionalDriver.text( api.additionalDriverCost() + '$' )
                $('#rent-cost-value').text( api.rentTotal() + '$' )
                $('#rent-cost-time-period').text( api.rentPeriods[ $.api.locale ][ api.rentPeriod() ] )

            total: ->
                if ( api.rentTotal() + api.gpsCost() + api.childSeatCost() + api.additionalDriverCost() )
                    return api.rentTotal() + api.gpsCost() + api.childSeatCost() + api.additionalDriverCost()
                else
                    0

            rentTotal: ->
                if ( api.rentDays() * api.prices[ api.rentPeriod() ] )
                    return ( api.rentDays() * api.prices[ api.rentPeriod() ] )
                else
                    0
            gpsCost: ->
                if $('input#rent_request_has_gps').is ':checked'
                    if api.rentDays() > 10 then api.prices.additionalServices.gps * 10 else api.prices.additionalServices.gps * api.rentDays()
                else
                    0
            childSeatCost: ->
                if $('input#rent_request_has_child_seat').is ':checked'
                    if api.rentDays() > 10 then api.prices.additionalServices.childSeat * 10 else api.prices.additionalServices.childSeat * api.rentDays()
                else
                    0
            additionalDriverCost: ->
                if $('input#rent_request_has_additional_driver').is ':checked'
                    if api.rentDays() > 10 then api.prices.additionalServices.additionalDriver * 10 else api.prices.additionalServices.additionalDriver * api.rentDays()
                else
                    0


        if $.api.action == 'new'
            data = $.parseJSON( $('div#rent-json-attributes').text() )

            api.prices =
                oneToTwo: data[0]
                threeToFive: data[1]
                sixToTwelve: data[2]
                thirteenToTwentyFour: data[3]
                month: data[4]
                additionalServices: {
                    gps: data[5].gps,
                    childSeat: data[5].child_seat,
                    additionalDriver: data[5].additional_driver
                }

            $('input#rent_request_has_gps').change ->
                api.additionalServices.gps.text( api.gpsCost() + '$' ).parents('div#gps-cost').slideToggle()
                api.displayTotal()
            $('input#rent_request_has_child_seat').change ->
                api.additionalServices.childSeat.text( api.childSeatCost() + '$' ).parents('div#child-seat-cost').slideToggle()
                api.displayTotal()
            $('input#rent_request_has_additional_driver').change ->
                api.additionalServices.additionalDriver.text( api.additionalDriverCost() + '$' ).parents('div#additional-driver-cost').slideToggle()
                api.displayTotal()

            $('input#rent_request_drop_off_at, input#rent_request_receipt_at').change ->
                api.recalculate()

            if ! $('form#new-rent-request').data('populated')
                if $.cookie('params')
                    params = $.cookie('params').split(',')

                    api.receiptLocation.val params[0]
                    api.dropOffLocation.val params[1]
                    api.dropOffAtReceipt.prop('checked', params[2] == 'true')
                    api.confirmDropOffLocation.prop('checked', params[3] == 'true')
                    api.receiptAt.val params[4]
                    api.dropOffAt.val params[5]
                    api.car.val params[6] if api.car
                    api.name.val params[7]
                    api.email.val params[8]
                    api.phone.val params[9]

                    if params[2] == 'true'
                        api.confirmDropOffLocation.prop('checked', false).parents('div.control-group').hide()
                        api.dropOffLocation.parents('div.control-group').hide()
                    if params[3] == 'true'
                        api.dropOffAtReceipt.prop('checked', false).parents('div.control-group').hide()
                        api.dropOffLocation.parents('div.control-group').hide()

                    api.recalculate()

                $(window).unload ->
                    values = [ api.receiptLocation.val(), api.dropOffLocation.val(), api.dropOffAtReceipt.is(':checked'), api.confirmDropOffLocation.is(':checked'),
                        api.receiptAt.val(), api.dropOffAt.val(), null, api.name.val(), api.email.val(), api.phone.val() ]

                    $.cookie('params', values.join(','), { path: '/' })


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

            if $.api.rentRequests.email.val().length == 0 || !validEmail( $.api.rentRequests.email.val() )
                fieldsWithErrors.push $.api.rentRequests.email.parents('div.control-group')

            if api.dropOffAt.datepicker('getDate') <= api.receiptAt.datepicker('getDate')
                fieldsWithErrors.push api.dropOffAt.parents('div.control-group')
                fieldsWithErrors.push api.receiptAt.parents('div.control-group')

            if fieldsWithErrors.length > 0
                $.each fieldsWithErrors, ->
                    this.addClass('error').removeClass('success')

                if $(this).find('div.alert-error').length == 0
                    $(this).append("<div class='alert alert-error margin-top'>" + errorsMessage + "</div>")


                false



