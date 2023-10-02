export default {
  mounted() {
    this.initHideShowFields();
  },

  methods: {
    initHideShowFields() {
      const $ = window.jQuery;

      $('#base_activity_base_activity_type_id').on('change', function() {
        let value = $('#base_activity_base_activity_type_id option:selected').text();
        if (value === 'Envio de documento') {
          $('.base_activity_identifier').removeClass('d-none').addClass('d-block');
          $('.base_activity_judgment').removeClass('d-none').addClass('d-block');
          $('.base_activity_final_version').removeClass('d-none').addClass('d-block');
        } else {
          $('.base_activity_identifier').removeClass('d-block').addClass('d-none');
          $('.base_activity_judgment').removeClass('d-block').addClass('d-none');
          $('.base_activity_final_version').removeClass('d-block').addClass('d-none');
        }
      });

    }
  }

};
