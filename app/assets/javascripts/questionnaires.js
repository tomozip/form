function add_inputbox_by_checked() {
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
