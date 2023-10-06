export default {
  mounted() {
    this.initExaminationBoardsHelper();
  },

  methods: {
    initExaminationBoardsHelper() {
      document.querySelectorAll('.examination-board-date').forEach(function(element) {
        const date = new Date(element.dataset.date);
        const parent = element.parentElement.parentElement;
        if (date.getTime() < new Date().getTime()) {
          parent.classList.add('opacity-50');
        }
      })

      document.querySelectorAll('.examination-details').forEach(function(element) {
        element.classList.add('hidden');
      });

      document.querySelectorAll('.showDetails').forEach(function(element) {
        element.addEventListener('click', function() {
          const examId = element.dataset.examId;
          document.querySelectorAll('.examination-details.exam_' + examId).forEach(function(element) {
            if (element.classList.contains('hidden')) {
              element.classList.remove('hidden');
            } else {
              element.classList.add('hidden');
            }
          });
        });
      }
      )
  
    }
  }
};
