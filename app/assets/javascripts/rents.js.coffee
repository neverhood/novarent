# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
    if document.body.id == 'rents'
        $('span.car-toggle-info').hover ->
            $(this).parents('div.car-specs').find('div.car-short-specs').slideToggle('fast')
