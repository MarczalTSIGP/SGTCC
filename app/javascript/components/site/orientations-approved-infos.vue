<template>
  <div>
    <div v-show="loading">
      <loader />
    </div>
    <div v-show="!loading">
      <div v-if="hasTccTwoFirstSemester">
        <h2 class="text-center">
          {{ firstSemesterLabel }}
        </h2>

        <orientations-info
          :orientations="orientations.first_semester"
        />
      </div>

      <div v-if="hasTccTwoSecondSemester">
        <h2 class="text-center">
          {{ secondSemesterLabel }}
        </h2>

        <orientations-info
          :orientations="orientations.second_semester"
        />
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsInfo from './orientations-info';
import Loader from '../shared/loader';

export default {
  name: 'OrientationApprovedInfos',

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

    hasTccTwoFirstSemester() {
      return this.isNotEmpty(this.orientations.first_semester);
    },

    hasTccTwoSecondSemester() {
      return this.isNotEmpty(this.orientations.second_semester);
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
        this.orientations.first_semester = data.first_semester;
        this.orientations.second_semester = data.second_semester;
        this.loading = false;
      });
    },

    isNotEmpty(data) {
      return data.length > 0;
    },
  },
};

</script>
