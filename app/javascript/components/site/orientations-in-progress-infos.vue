<template>
  <div>
    <div v-show="loading">
      <loader />
    </div>
    <div v-show="!loading">
      <h2 class="page-title text-center">
        {{ firstSemesterLabel }}
      </h2>

      <h3 class="page-title">
        TCC 1
      </h3>

      <orientations-info
        :orientations="orientations.tcc_one.first_semester"
      />

      <h3 class="page-title">
        TCC 2
      </h3>

      <orientations-info
        :orientations="orientations.tcc_two.first_semester"
      />

      <h2 class="page-title text-center">
        {{ secondSemesterLabel }}
      </h2>

      <h3 class="page-title">
        TCC 1
      </h3>

      <orientations-info
        :orientations="orientations.tcc_one.second_semester"
      />

      <h3 class="page-title">
        TCC 2
      </h3>

      <orientations-info
        :orientations="orientations.tcc_two.second_semester"
      />
    </div>
  </div>
</template>

<script>

import OrientationsInfo from './orientations-info';
import Loader from '../shared/loader';

export default {
  name: 'OrientationInProgressInfos',

  components: {
    Loader,
    OrientationsInfo
  },

  data() {
    return {
      year: '',
      firstSemester: 1,
      secondSemester: 2,
      loading: true,
      orientations: {
        tcc_one: {
          first_semester: [],
          second_semester: []
        },
        tcc_two: {
          first_semester: [],
          second_semester: []
        },
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

  created() {
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
        this.loading = true;
        this.orientations.tcc_one.first_semester = data.tcc_one.first_semester;
        this.orientations.tcc_one.second_semester = data.tcc_one.second_semester;
        this.orientations.tcc_two.first_semester = data.tcc_two.first_semester;
        this.orientations.tcc_two.second_semester = data.tcc_two.second_semester;

        this.loading = false;
      });
    },
  },
};

</script>
