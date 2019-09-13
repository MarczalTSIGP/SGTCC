<template>
  <div>
    <h2 class="page-title text-center">
      {{ firstSemesterLabel }}
    </h2>

    <orientations-table
      :orientations="orientations.first_semester"
    />

    <h2 class="page-title text-center">
      {{ secondSemesterLabel }}
    </h2>

    <orientations-table
      :orientations="orientations.second_semester"
    />
  </div>
</template>

<script>

import OrientationsTable from './orientations-table';

export default {
  name: 'OrientationTables',

  components: { OrientationsTable },

  props: {
    data: {
      type: Array,
      required: true
    },
  },

  data() {
    return {
      year: '',
      firstSemester: 1,
      secondSemester: 2,
      orientations: {
        first_semester: [],
        second_semester: []
      },
    };
  },

  computed: {
    firstSemesterLabel() {
      return `${this.year}/${this.firstSemester}`;
    },

    secondSemesterLabel() {
      return `${this.year}/${this.secondSemester}`;
    },
  },

  mounted() {
    this.onUpdateOrientations();
    this.onUpdateCalendarYear();
  },

  methods: {
    onUpdateCalendarYear() {
      this.$root.$on('site-update-calendar-year', (year) => {
        this.year = year;
      });
    },

    onUpdateOrientations() {
      this.$root.$on('site-update-orientations', (data) => {
        this.orientations.first_semester = data.first_semester;
        this.orientations.second_semester = data.second_semester;
      });
    },
  },
};

</script>
