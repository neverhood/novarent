# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
    if document.body.id == 'driving-services'
        $('span.car-toggle-info').hover ->
            $(this).parents('div.driving-service').find('div.car-short-specs').slideToggle('fast')
