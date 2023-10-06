export default {
  mounted() {
    this.initHideShowFields();
  },

  methods: {
    initHideShowFields() {
      const $ = window.jQuery;
      const elClass = '.activity_type_hide_event';
      
      if ($(elClass).length <= 0) return;

      const baseActivitiesTypes = JSON.parse($(elClass).attr('base-activities-types'));

      $(elClass).on('change', function() {
        
        const value = parseInt($(this).find('option:selected').attr('value'));
        if (isNaN(value)) return;

        if (baseActivitiesTypes[value] === 'info') {
          $('[hide-on-activity-type-info-selected]').hide();
        } else {
          $('[hide-on-activity-type-info-selected]').show();
        }
      });

      $(elClass).trigger('change');
    }
  }
};
