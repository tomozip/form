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
            num_choice_field = $('#num_choice');
        if (category == 'checkbox' || category == 'radio' || category == 'selectbox') {
            if (!num_choice_field.length) {
                $('#category_select').after('<select id="num_choice" name="num_choice"></select>');
                for (var i = 2; i < 11 ; i++) {
                    $('#num_choice').append('<option value="' + i + '">' + i + '個</option>')
                }
            }
        } else {
            num_choice_field.length && num_choice_field.remove();
        }
    });
}
