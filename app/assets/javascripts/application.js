//= require jquery
//= require bootstrap-sprockets

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//
//= require jquery_ujs
//= require turbolinks
//= require_tree .


function questionnaire() {
    const wrap = $('#category-select-wrap'),
        question_wrap = $('#question-field-wrap');
    $('#category_select').change(() => {
        const category = $("#category_select").val(),
            numChoice_field = $('#numChoice');
        if (category == 'checkbox' || category == 'radio' || category == 'selectbox') {
            if (!numChoice_field.length) {
                $('#category_select').after('<select id="numChoice" name="numChoice"></select>');
                for (var i = 2; i < 11 ; i++) {
                    $('#numChoice').append('<option value="' + i + '">' + i + '個</option>')
                }
            }
        } else {
            numChoice_field.length && numChoice_field.remove();
        }
    });
}
