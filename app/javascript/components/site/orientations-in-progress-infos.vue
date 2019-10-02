<template>
  <div>
    <div v-show="loading">
      <loader />
    </div>
    <div v-show="!loading">
      <div v-show="hasTccOneFirstSemester || hasTccTwoFirstSemester">
        <h2 class="text-center">
          {{ firstSemesterLabel }}
        </h2>

        <div v-show="hasTccOneFirstSemester">
          <h3>TCC 1</h3>

          <orientations-info
            :orientations="orientations.tcc_one.first_semester"
          />
        </div>

        <div v-show="hasTccTwoFirstSemester">
          <h3>TCC 2</h3>

          <orientations-info
            :orientations="orientations.tcc_two.first_semester"
          />
        </div>
      </div>

      <div v-show="hasTccOneSecondSemester || hasTccTwoSecondSemester">
        <h2 class="text-center">
          {{ secondSemesterLabel }}
        </h2>

        <div v-show="hasTccOneSecondSemester">
          <h3>TCC 1</h3>

          <orientations-info
            :orientations="orientations.tcc_one.second_semester"
          />
        </div>

        <div v-show="hasTccTwoSecondSemester">
          <h3>TCC 2</h3>

          <orientations-info
            :orientations="orientations.tcc_two.second_semester"
          />
        </div>
      </div>
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

    hasTccOneFirstSemester() {
      return this.isNotEmpty(this.orientations.tcc_one.first_semester);
    },

    hasTccTwoFirstSemester() {
      return this.isNotEmpty(this.orientations.tcc_two.first_semester);
    },

    hasTccOneSecondSemester() {
      return this.isNotEmpty(this.orientations.tcc_one.second_semester);
    },

    hasTccTwoSecondSemester() {
      return this.isNotEmpty(this.orientations.tcc_two.second_semester);
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

    isNotEmpty(data) {
      return data.length > 0;
    },
  },
};

</script>
