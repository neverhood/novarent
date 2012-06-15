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
            type: $('div#new-rent-request-container').data('request-type')
            additionalServices:
                gps: $('#gps-cost-value')
                childSeat: $('#child-seat-cost-value')
                additionalDriver: $('#additional-driver-cost-value')
            rentPeriods:
                rent:
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
                driving_service:
                    ru:
                        '': ''
                    en:
                        '': ''

                special_rent:
                    ru:
                        'fridayToMonday': 'Пятница - Понедельник'
                        'thursdayToMonday': 'Четверг - Понедельник'
                        'fridayToTuesday': 'Пятница - Вторник'
                    en:
                        'fridayToMonday': 'Friday - Monday'
                        'thursdayToMonday': 'Thursday - Monday'
                        'fridayToTuesday': 'Friday - Tuesday'

            deliveryCost: ->
                cost = 0
                cost = api.cityDeliveryCost if $.inArray( api.receiptLocation.val(), api.deliveryLocations ) == -1

                cost
            returnCost: ->
                cost = 0

                if api.dropOffAtReceipt.is(':checked')
                    cost = api.deliveryCost()
                else if $.inArray(  api.dropOffLocation.val(), api.deliveryLocations ) == -1 or api.confirmDropOffLocation.is(':checked')
                    cost = api.cityDeliveryCost

                cost
            rentDays: ->
                if api.type == 'rent' or api.type == 'driving_service'
                    endRaw = $('#rent_request_drop_off_at').val().split(/\.| |:/)
                    startRaw = $('#rent_request_receipt_at').val().split(/\.| |:/)
                    start = new Date(startRaw[2], startRaw[1], startRaw[0], startRaw[3], startRaw[4])
                    end = new Date(endRaw[2], endRaw[1], endRaw[0], endRaw[3], endRaw[4])

                    Math.ceil( ( end - start ) / ( 1000*60*60*24 ) )
                else
                    if $('input#rent_request_special_time_period_0').is(':checked')
                        3
                    else if $('input#rent_request_special_time_period_1').is(':checked')
                        4
                    else if $('input#rent_request_special_time_period_2').is(':checked')
                        4
                    else
                        0

            rentPeriod: ->
                if api.type == 'rent'
                    days = $.api.rentRequests.rentDays()
                    period = 'unknown'

                    period = 'unknown' if days <= 0
                    if days <= 0
                        period = 'unknown'
                    else if days < 3
                        period = 'oneToTwo'
                    else if days < 6
                        period = 'threeToFive'
                    else if days < 13
                        period = 'sixToTwelve'
                    else if days < 25
                        period = 'thirteenToTwentyFour'
                    else
                        period = 'month'
                if api.type == 'special_rent'
                    if $('input#rent_request_special_time_period_0').is(':checked')
                        period = 'fridayToMonday'
                    else if $('input#rent_request_special_time_period_1').is(':checked')
                        period = 'thursdayToMonday'
                    else if $('input#rent_request_special_time_period_2').is(':checked')
                        period = 'fridayToTuesday'

                return period

            displayTotal: ->
                $('#rent-request-cost-total').text( api.total() + '$' )
            recalculate: ->
                api.displayTotal()
                api.additionalServices.gps.text( api.gpsCost() + '$' )
                api.additionalServices.childSeat.text( api.childSeatCost()  + '$' )
                api.additionalServices.additionalDriver.text( api.additionalDriverCost() + '$' )
                $('span#delivery-cost-value').text( api.deliveryCost() + '$' )
                $('span#return-cost-value').text( api.returnCost() + '$' )
                $('#rent-cost-value').text( api.rentTotal() + '$' )
                $('#rent-cost-time-period').text( api.rentPeriods[ api.type ][ $.api.locale ][ api.rentPeriod() ] )

            total: ->
                if ( api.rentTotal() + api.gpsCost() + api.childSeatCost() + api.additionalDriverCost() )
                    return api.rentTotal() + api.gpsCost() + api.childSeatCost() + api.additionalDriverCost() + api.deliveryCost() + api.returnCost()
                else
                    0

            rentTotal: ->
                return 0 if api.rentDays() <= 0
                if api.type == 'rent'
                    ( api.rentDays() * api.prices[ api.rentPeriod() ] ) || 0
                else if api.type == 'special_rent'
                    api.prices[ api.rentPeriod() ] || 0
            gpsCost: ->
                return 0 if api.rentDays() <= 0
                if $('input#rent_request_has_gps').is ':checked'
                    cost = if api.rentDays() > 10 then api.prices.additionalServices.gps * 10 else api.prices.additionalServices.gps * api.rentDays()
                    cost = 0 unless cost
                    cost
                else
                    0
            childSeatCost: ->
                return 0 if api.rentDays() <= 0
                if $('input#rent_request_has_child_seat').is ':checked'
                    numberOfSeats = parseInt( $('select#rent_request_number_of_babe_seats').val() ) + parseInt( $('select#rent_request_number_of_child_seats').val() )
                    cost = numberOfSeats * api.prices.additionalServices.childSeat * api.rentDays()
                    cost = 0 unless cost
                    cost = 50 if cost > 50
                    cost
                else
                    0
            additionalDriverCost: ->
                return 0 if api.rentDays() <= 0
                if $('input#rent_request_has_additional_driver').is ':checked'
                    cost = if api.rentDays() > 10 then api.prices.additionalServices.additionalDriver * 10 else api.prices.additionalServices.additionalDriver * api.rentDays()
                    cost = 0 unless cost
                    cost
                else
                    0


        if $.api.action == 'new'
            data = $.parseJSON( $('div#rent-json-attributes').text() )
            api.cityDeliveryCost = parseInt $('div#delivery-prices').text()
            api.deliveryLocations = $.parseJSON $('div#delivery-places').text()

            # Prices
            if api.type == 'rent'
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
            else if api.type == 'driving_service'
                api.prices =
                    cost: data[0],
                    oneHour: data[2],
                    transfer: data[3]
            else
                api.prices =
                    fridayToMonday: data[0],
                    thursdayToMonday: data[1],
                    fridayToTuesday: data[2]
                    additionalServices: {
                        gps: data[3].gps,
                        childSeat: data[3].child_seat,
                        additionalDriver: data[3].additional_driver
                    }



            $('select#rent_request_number_of_babe_seats, select#rent_request_number_of_child_seats').change ->
                api.additionalServices.childSeat.text( api.childSeatCost() + '$' )
                api.displayTotal()

            $('input#rent_request_has_gps').change ->
                api.additionalServices.gps.text( api.gpsCost() + '$' ).parents('div#gps-cost').slideToggle()
                api.displayTotal()
            $('input#rent_request_has_child_seat').change ->
                $('div#child-seat-options').slideToggle()
                api.additionalServices.childSeat.text( api.childSeatCost() + '$' ).parents('div#child-seat-cost').slideToggle()
                api.displayTotal()
            $('input#rent_request_has_additional_driver').change ->
                api.additionalServices.additionalDriver.text( api.additionalDriverCost() + '$' ).parents('div#additional-driver-cost').slideToggle()
                api.displayTotal()

            $('input#rent_request_drop_off_at, input#rent_request_receipt_at, input#rent_request_special_time_period_0, input#rent_request_special_time_period_1, input#rent_request_special_time_period_2').change ->
                api.recalculate() unless api.type == 'driving_service'

            if api.type == 'driving_service'
                $('select#rent_request_driving_service').change ->
                    if this.value == '0'
                        $('input#rent_request_receipt_at, input#rent_request_drop_off_at').slideDown('fast').prop('disabled', false)
                    if this.value == '1'
                        $('input#rent_request_drop_off_at').slideUp('fast')
                        $('input#rent_request_receipt_at').prop('disabled', false)
                    if this.value == ''
                        $('input#rent_request_receipt_at, input#rent_request_drop_off_at').slideDown('fast').prop('disabled', true)

            if ! $('form#new-rent-request').data('populated')
                if $.cookie('params')
                    params = $.cookie('params').split(',')

                    api.receiptLocation.val params[0]
                    api.dropOffLocation.val params[1]
                    api.dropOffAtReceipt.prop('checked', params[2] == 'true')
                    api.confirmDropOffLocation.prop('checked', params[3] == 'true')
                    api.receiptAt.val params[4] if api.type == 'rent'
                    api.dropOffAt.val params[5] if api.type == 'rent'
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

                    if api.deliveryLocations[ api.receiptLocation.val() ]
                        console.log 'delivery: ' + api.deliveryPrices[ api.deliveryLocations[ api.receiptLocation.val() ] ]

                    if api.deliveryLocations[ api.dropOffLocation.val() ] or ( api.deliveryLocations[ api.receiptLocation.val() ] and api.dropOffAtReceipt.is(':checked') )
                        console.log 'drop off: ' + api.deliveryPrices[ api.deliveryLocations[ api.receiptLocation.val() ] ]

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

            api.recalculate()

        $('input#rent_request_confirm_drop_off_location').change ->
            $('input#rent_request_drop_off_location').parents('div.control-group').slideToggle()
            $('input#rent_request_drop_off_at_receipt').prop('checked', false).parents('div.control-group').slideToggle()

            api.recalculate()

        $.datepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )
        $.timepicker.setDefaults( $.datepicker.regional[ $.api.locale ] )

        if api.type == 'driving_service' or api.type == 'rent'
            $('input#rent_request_drop_off_at, input#rent_request_receipt_at').datetimepicker(showButtonPanel: false, stepMinute: 10, minDate: new Date)
        if api.type == 'special_rent'

            $('input#rent_request_special_time_period_0').click ->
                input = $('input#rent_request_receipt_at')
                $('input#rent_request_receipt_at').datepicker('destroy').datepicker(
                    beforeShowDay: (date) -> [( date.getDay() == 5 ), '']
                    onSelect: (dateText, inst) ->
                        rawDate = dateText.split('.')
                        date = new Date( rawDate[2], rawDate[1], rawDate[0] )
                        date.setDate( date.getDate() + 2 )
                        date.setMonth( date.getMonth() - 1 )
                        $('input#rent_request_drop_off_at').val( $.datepicker.formatDate('dd.mm.yy', date) + ' 10:00' )
                        this.value = dateText + ' 12:00'

                        $('div#special-rent-period-section').find('div.error').removeClass('error')
                    numberOfMonths: 3
                    minDate: new Date
                ).datepicker('show')

            $('input#rent_request_special_time_period_1').click ->
                $('input#rent_request_receipt_at').datepicker('destroy').datepicker(
                    beforeShowDay: (date) -> [( date.getDay() == 4), '']
                    onSelect: (dateText, inst) ->
                        rawDate = dateText.split('.')
                        date = new Date( rawDate[2], rawDate[1], rawDate[0] )
                        date.setDate( date.getDate() + 4)
                        date.setMonth( date.getMonth() - 1)
                        $('input#rent_request_drop_off_at').val( $.datepicker.formatDate('dd.mm.yy', date) + ' 10:00' )
                        this.value = dateText + ' 12:00'

                        $('div#special-rent-period-section').find('div.error').removeClass('error')
                    numberOfMonths: 3
                    minDate: new Date
                ).datepicker('show')

            $('input#rent_request_special_time_period_2').click ->
                $('input#rent_request_receipt_at').datepicker('destroy').datepicker(
                    beforeShowDay: (date) -> [( date.getDay() == 5), '']
                    onSelect: (dateText, inst) ->
                        rawDate = dateText.split('.')
                        date = new Date( rawDate[2], rawDate[1], rawDate[0] )
                        date.setDate( date.getDate() + 4)
                        date.setMonth( date.getMonth() - 1)
                        $('input#rent_request_drop_off_at').val( $.datepicker.formatDate('dd.mm.yy', date) + ' 10:00' )
                        this.value = dateText + ' 12:00'

                        $('div#special-rent-period-section').find('div.error').removeClass('error')
                    numberOfMonths: 3
                    minDate: new Date
                ).datepicker('show')

        $('input#rent_request_receipt_location, input#rent_request_drop_off_location').autocomplete(
            source: $.api.locations[ $.api.locale ]
            minLength: 0
            select: (event, ui) ->
                $(this).parents('div.control-group').removeClass('error')
            change: (event, ui) ->
                console.log( this.value )
                api.recalculate()
        ).keyup ->
            api.recalculate()

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
                unless api.type == 'driving_service' and $('select#rent_request_driving_service').val() == 1
                    fieldsWithErrors.push $.api.rentRequests.dropOffAt.parents('div.control-group')

            if $.api.rentRequests.name.val().length == 0
                fieldsWithErrors.push $.api.rentRequests.name.parents('div.control-group')

            if $.api.rentRequests.email.val().length == 0 || !validEmail( $.api.rentRequests.email.val() )
                fieldsWithErrors.push $.api.rentRequests.email.parents('div.control-group')

            if api.rentDays() <= 0
                unless api.type == 'driving_service' and $('select#rent_request_driving_service').val() == "1"
                    fieldsWithErrors.push api.dropOffAt.parents('div.control-group')
                    fieldsWithErrors.push api.receiptAt.parents('div.control-group')

            if fieldsWithErrors.length > 0
                $.each fieldsWithErrors, ->
                    this.addClass('error').removeClass('success')

                if $(this).find('div.alert-error').length == 0
                    $(this).append("<div class='alert alert-error margin-top'>" + errorsMessage + "</div>")

                false



