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

function answer_new() {
    $('#normal').on('click', () => {
        $('.warning').remove();
        const lists = $('li');
        const warning = '<div class="warning">回答してください。</div>';
        var all_values_isFull = true;
        lists.each((index, element) => {
          if (value_isNull($(element))) {
              $(element).after(warning)
              all_values_isFull = false;
          }
        });
        if (all_values_isFull)
          $('#new_answer').submit();
        else return false;
    });
    $('#temporary').on('click', () => {
        $('.warning').remove();
        const lists = $('li');
        const warning = '<div class="warning">一つ以上回答してください。</div>';
        let all_values_isNull = true;
        lists.each((index, element) => {
          if (!value_isNull($(element))) all_values_isNull = false;
        });
        if (all_values_isNull) {
          $('ol').prepend(warning);
          return false;
        } else {
          $('#new_answer').submit();
        }
    });

    function value_isNull(element) {
        const category = $(element).children('*:nth-child(2)').prop('type');
        switch (category) {
          case 'text':
          case 'textarea':
          case 'select-one':
            return !$(element).children('*:nth-child(2)').val();
          case 'radio':
          case 'checkbox':
              var value_isNull = true;
              element.children('input[type="' + category + '"]').each((i, e) => {
                  if ($(e).prop('checked')) value_isNull = false;
              });
              return value_isNull;
        }
    }
}
