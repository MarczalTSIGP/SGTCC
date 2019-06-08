export default {
  mounted() {
    this.initScroll();
  },

  methods: {
    initScroll() {
      const $ = window.jQuery;
      const linkActive = $('a.list-group-item.list-group-item-action.active');
      const top = linkActive.offset().top;

      if (top >= 474) {
        this.moveScrollToActiveLinkPosition(top);
      }
    },

    moveScrollToActiveLinkPosition(position) {
      const $ = window.jQuery;

      $('.sidebar').animate({
        scrollTop: position
      }, 2000);
    },
  },
};
