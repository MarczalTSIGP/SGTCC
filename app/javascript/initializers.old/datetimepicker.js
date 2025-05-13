export default {
  mounted() {
    this.initLinkedPicker();
  },

  methods: {
    initLinkedPicker() {
      const $ = window.jQuery;
      const activity_initial_date = '#datetimepicker_activity_initial_date';
      const activity_final_date = '#datetimepicker_activity_final_date';

      if ($(activity_initial_date).length === 0) {
        return false;
      }

      $(activity_final_date).datetimepicker({ useCurrent: false });

      $(activity_initial_date).on('change.datetimepicker', (e) => {
        $(activity_final_date).datetimepicker('minDate', e.date);
      });

      $(activity_final_date).on('change.datetimepicker', (e) => {
        $(activity_initial_date).datetimepicker('maxDate', e.date);
      });
    },
  }
};
