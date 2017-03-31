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
            numChoice_field.length || $('#category_select').after('<input type="text" id="numChoice" name="numChoice" placeholder="選択肢の個数">')
        } else {
            numChoice_field.length && numChoice_field.remove();
        }
    });

    $('#category-btn').on('click', () => {
        const post_data = {
          category: $('#category-select').val(),
          numChoice_field: $('#numChoice').val()
        };
        // $.ajax({
        //   async: true
        //   url: $('#category-btn').attr('href'),
        //   type: 'POST',
        //   data: post_data,
        //   dataType: 'json',
        //   cache: false
        // });
        $.ajax({
          type: "POST",
          url: $('#category-btn').attr('href'),
          cache: false,
          data: post_data,
          dataType: 'json'
        });
    });
}
