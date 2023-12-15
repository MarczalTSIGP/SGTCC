import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
console.log($);

export default {
  mounted() {
    this.initHeaderMenuCollapse();
  },

  methods: {
    initHeaderMenuCollapse() {
      $('[data-toggle="collapse"]').click(function() {
        $("html, body").animate({ scrollTop: 0 }, "slow");
      });
    }
  }
};
