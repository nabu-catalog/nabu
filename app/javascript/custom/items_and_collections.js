import {setup_select2} from 'custom/select2_setup';

$(function () {

  // Add more fields to form
  $('form').on('click', '.add_fields', function (event) {
    const time = new Date().getTime()
    const regexp = new RegExp($(this).data('id'), 'g')

    $(this).before($(this).data('fields').replace(regexp, time));
    setup_select2($(this).prev().prev()); // eslint-disable-line no-undef
    setup_select2($(this).prev()); // eslint-disable-line no-undef
    event.preventDefault();
  });


  // Set up select2 elements
  $(".select2").each(function() {
    setup_select2(this); // eslint-disable-line no-undef
  });

  // Fix _ids hidden fields for select2
  $('form').on('submit', function () {
    const form = $(this)
    form.find('input[type=hidden].select2').each(function () {
      const input = $(this);
      if (input.attr('name').match(/_ids]$/) && $(this).val() != '') {
        const ids = input.val().split(/,/);
        ids.forEach(function (id) {
          form.append($('<input type=hidden name="' + input.attr('name') + '[]" value="' + id + '" />'));
          input.remove();
        });
      }
    });
  });
});
