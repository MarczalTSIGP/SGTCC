export default {
  mounted() {
    this.moveScrollToActiveLinkPosition();
    this.addClickEventToAllLinksToGetScrollPosition();
  },

  methods: {
    moveScrollToActiveLinkPosition() {
      const $ = window.jQuery;
      var position = parseInt(localStorage.getItem('scroll_top_position')) || 0;

      $('.sidebar').scrollTop(position);
      $('.sidebar').css('overflow', 'auto');
    },

    addClickEventToAllLinksToGetScrollPosition() {
      const $ = window.jQuery;

      $('body').on('click', 'a', function() {
        let scrollTop = $('.sidebar').scrollTop();

        localStorage.setItem('scroll_top_position', scrollTop);
      });
    }
  },
};
