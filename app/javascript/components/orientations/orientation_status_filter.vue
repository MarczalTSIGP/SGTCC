<template>
  <div class="form-group select orientation_status_filter">
    <select
      id="orientation_status"
      data="status-selectize"
      name="orientation[status]"
      class="form-control select required"
      @change="filterByStatus($event.target.value)"
    >
      <option value="">
        {{ $t('select.all.f') }}
      </option>
      <option
        v-for="(option, index) in options"
        :key="index"
        :value="option[0]"
        :selected="matchUrl(option[0])"
      >
        {{ option[1] }}
      </option>
    </select>
  </div>
</template>

<script>
export default {
  name: 'OrientationStatusFilter',

  props: {
    options: {
      type: Array,
      required: true,
    },
  },

  mounted() {
    this.updateFilter();
  },

  methods: {
    filterByStatus(filter) {
      this.$root.$emit('search-with-filter', filter);
    },

    matchUrl(status) {
      return window.location.href.match(status);
    },

    updateFilter() {
      const filter = this.options.filter((option) => {
        return this.matchUrl(option[0]);
      });

      if (filter.length > 0) {
        this.$root.$emit('update-search-url', filter[0]);
      }
    },
  },
};
</script>
