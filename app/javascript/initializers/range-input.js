export default {
  mounted() {
    this.initRangeInput();
  },

  methods: {
    initRangeInput() {
      const elements = document.getElementsByClassName('range_tabler');

      Array.from(elements).forEach((element) => {
        const display = element.querySelector('.range-display');
        const input = element.querySelector('.form-control-range');

        input.addEventListener('input', (event) => {
          display.innerHTML = input.value;

          const value = event.target.value; 
          const percentage = (value / input.max) * 100;
          input.style.background = `linear-gradient(to right, #467fcf ${percentage}%, #ccc ${percentage}%)`;
        });
      });
    }
  }
};
