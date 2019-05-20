export default {
  mounted() {
    this.initTooltip();
  },

  methods: {
    initTooltip() {
      const $ = window.jQuery;

      $('[data-toggle="tooltip"]').tooltip({
        container: '#main-card'
      });
    },
  },
};
