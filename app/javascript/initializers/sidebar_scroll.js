export default {
  mounted() {
    this.initScroll();
  },

  methods: {
    initScroll() {
      const $ = window.jQuery;
      const linkActive = $('a.list-group-item.list-group-item-action.active');

      $('.sidebar').animate({
        scrollTop: linkActive.offset().top
      }, 2000);
    },
  },
};
