export default {
  mounted() {
    this.initHeaderMenuCollapse();
  },

  methods: {
    initHeaderMenuCollapse() {
      const $ = window.jQuery;

      $('[data-toggle="collapse"]').click(function() {
        $('html, body').animate({ scrollTop: 0 }, 'slow');
      });
    },
  },
};
