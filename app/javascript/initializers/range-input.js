export default {
  mounted() {
    this.initRangeInput();
  },

  methods: {
    initRangeInput() {
      $(".form-control-range").on("input", function() {
        const display = $(this)
          .siblings()
          .find(".range-display");
        display.text($(this).val());
      });
    }
  }
};
