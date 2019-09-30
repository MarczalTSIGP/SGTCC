<template>
  <div class="input-group mb-3">
    <div class="input-group-prepend">
      <button
        class="btn btn-outline-primary"
        :disabled="hasNotPreviousYear"
        @click="setSelectedYear(previousYear)"
      >
        <i class="fe fe-chevrons-left" />
      </button>
    </div>
    <select
      v-model="selectedYear"
      class="site-select custom-select"
    >
      <option
        v-for="(year, index) in years"
        :key="index"
        :value="year"
      >
        {{ year }}
      </option>
    </select>
    <div class="input-group-append">
      <button
        class="btn btn-outline-primary"
        :disabled="hasNotNextYear"
        @click="setSelectedYear(nextYear)"
      >
        <i class="fe fe-chevrons-right" />
      </button>
    </div>
  </div>
</template>

<script>

export default {
  name: 'SelectCalendarsByYear',

  props: {
    years: {
      type: Array,
      required: true
    },

    path: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      previousYear: '',
      selectedYear: '',
      nextYear: '',
    };
  },

  computed: {
    url() {
      return `${this.path}/${this.selectedYear}`;
    },

    hasNotPreviousYear() {
      return !this.hasYear(this.previousYear);
    },

    hasNotNextYear() {
      return !this.hasYear(this.nextYear);
    },
  },

  watch: {
    selectedYear() {
      this.updateYears();
      this.emitUpdateOrientations();
      this.emitUpdateSelectedYear();
    },
  },

  mounted() {
    this.setSelectedYear();
  },

  methods: {
    setSelectedYear(year = this.years[0]) {
      this.selectedYear = year;
    },

    updateYears() {
      this.nextYear = parseInt(this.selectedYear) + 1;
      this.previousYear = parseInt(this.selectedYear) - 1;
    },

    async emitUpdateOrientations() {
      const orientations = await this.$axios.post(this.url);
      this.$root.$emit('site-update-orientations', orientations.data);
    },

    emitUpdateSelectedYear() {
      this.$root.$emit('site-update-calendar-year', this.selectedYear);
    },

    hasYear(year) {
      return this.years.includes(year.toString());
    },
  },
};

</script>
