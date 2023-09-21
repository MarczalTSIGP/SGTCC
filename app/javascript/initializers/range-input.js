export default {
  mounted() {
    this.initRangeInput();
  },

  methods: {
    initRangeInput() {
      const elements = document.getElementsByClassName('range_tabler');

      Array.from(elements).forEach((element) => {
        const display = element.getElementsByClassName('range-display')[0];
        const input = element.getElementsByClassName('form-control-range')[0];
        input.addEventListener('input', () => {
          display.innerHTML = input.value;
        });

      });
    }
  }
};
