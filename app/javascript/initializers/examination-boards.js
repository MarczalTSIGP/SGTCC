export default {
  mounted() {
    this.initExaminationBoardsHelper();
  },

  methods: {
    initExaminationBoardsHelper() {
      document.querySelectorAll('.show-eb-details').forEach(function(element) {
        element.addEventListener('click', function(event) {
          const ebId = this.dataset.ebId;
          const el = document.getElementById('eb-' + ebId);
            if (el.classList.contains('d-none')) {
              el.classList.remove('d-none');
            } else {
              el.classList.add('d-none');
            }
            event.preventDefault()
        });
      });
    }
  }
};
