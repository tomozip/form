function validate_user_input() {
    $('#normal').on('click', () => {
        $('.js-warning').remove();
        const lists = $('li');
        const warning = '<div class="js-warning">回答してください。</div>';
        var all_values_isFull = true;
        lists.each((index, element) => {
          if (value_is_null($(element))) {
              $(element).after(warning)
              all_values_isFull = false;
          }
        });
        if (all_values_isFull)
          $('#new_answer').submit();
        else return false;
    });
    $('#temporary').on('click', () => {
        $('.js-warning').remove();
        const lists = $('li');
        const warning = '<div class="js-warning">一つ以上回答してください。</div>';
        let all_values_is_null = true;
        lists.each((index, element) => {
          if (!value_is_null($(element))) all_values_is_null = false;
        });
        if (all_values_is_null) {
          $('ol').prepend(warning);
          return false;
        } else {
          $('#new_answer').submit();
        }
    });

    function value_is_null(element) {
        const category = $(element).children('*:nth-child(2)').prop('type');
        switch (category) {
          case 'text':
          case 'textarea':
          case 'select-one':
            return !$(element).children('*:nth-child(2)').val();
          case 'radio':
          case 'checkbox':
              var value_is_null = true;
              element.children('input[type="' + category + '"]').each((i, e) => {
                  if ($(e).prop('checked')) value_is_null = false;
              });
              return value_is_null;
        }
    }
}
