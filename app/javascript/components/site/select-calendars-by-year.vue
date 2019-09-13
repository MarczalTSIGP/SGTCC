<template>
  <div class="input-group mb-3">
    <div class="input-group-prepend">
      <button
        class="btn btn-outline-primary"
      >
        <i class="fe fe-chevrons-left" />
      </button>
    </div>
    <select
      v-model="selectedYear"
      class="custom-select"
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
      <button class="btn btn-outline-primary">
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
      selectedYear: '',
    };
  },

  computed: {
    url() {
      return `${this.path}/${this.selectedYear}`;
    },
  },

  watch: {
    selectedYear() {
      this.emitUpdateOrientations();
    },
  },

  mounted() {
    this.setSelectedYear();
  },

  methods: {
    setSelectedYear() {
      this.selectedYear = this.years[0];
    },

    async emitUpdateOrientations() {
      const orientations = await this.$axios.post(this.url);
      this.$root.$emit('site-update-orientations', orientations.data);
    },
  },
};

</script>
