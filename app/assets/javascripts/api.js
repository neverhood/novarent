$.api = {
    locations: {
        ru: [ 'Аэропорт Борисполь', 'Аэропорт Жуляны', 'Ж/Д Вокзал' ],
        en: [ 'Airport Borispol', 'Airport Zhulyany', 'Railstation' ]
    }
}

$(document).ready(function() {

    $.api.controller = document.body.id;
    $.api.action = document.body.attributes['data-action'].value;
    $.api.locale = document.body.attributes['data-locale'].value;

});
