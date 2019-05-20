export default {
  mounted() {
    this.initSelectize();
    this.initCalendarSelectize();
  },

  methods: {
    initSelectize() {
      const $ = window.jQuery;
      const selects = $('*[data="selectize"]');

      if (selects.length > 0) {
        selects.selectize();
        this.fixSelectizePlaceholder();
      }
    },

    initCalendarSelectize() {
      const $ = window.jQuery;
      const select = $('*[data="calendar-selectize"]');

      if (select.length > 0) {
        select.selectize({
          onChange: function() {
            $('input[name="commit"]').click();
          }
        });
      }
      this.fixSelectizePlaceholder();
    },

    fixSelectizePlaceholder() {
      const $ = window.jQuery;
      $('.selectize-input input[placeholder]').attr('style', 'width: 100%;');
    },
  }
};
