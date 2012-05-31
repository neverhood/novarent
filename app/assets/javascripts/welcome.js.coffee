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

            ruErrors:
                receiptLocation: 'Место выдачи не указано'
                dropOffLocation: 'Место возврата не указано'
                receiptAt: 'Дата выдачи не указана'
                dropOffAt: 'Дата возврата не указана'
                car: 'Машина не выбрана'
                name: 'Имя не введено'
                email: 'E-mail не указан'

            errors: ->
                if $.api.locale == 'ru'
                    $.api.welcome.ruErrors
                else
                    $.api.welcome.enErrors


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

            if $.api.welcome.email.val().length == 0
                fieldsWithErrors.push $.api.welcome.email.parents('div.control-group')

            if fieldsWithErrors.length > 0
                $.each fieldsWithErrors, ->
                    this.addClass('error').removeClass('success')

                false


