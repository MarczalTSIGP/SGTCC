<template>
  <div class="form-group select orientation_status_filter">
    <select
      id="orientation_status"
      data="selectize"
      name="orientation[status]"
      class="form-control select required"
    >
      <option value="ALL">
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
      required: true
    }
  },

  mounted() {
    this.listenOnChange();
    this.updateFilter();
  },

  methods: {
    listenOnChange() {
      const $ = window.jQuery;
      $('#orientation_status').on('change', event => {
        let status = event.target.value;
        if (status === 'ALL') {
          status = '';
        }
        this.filterByStatus(status);
      });
    },

    filterByStatus(filter) {
      this.$root.$emit('search-with-filter', filter);
    },

    matchUrl(status) {
      return window.location.href.match(status);
    },

    updateFilter() {
      const filter = this.options.filter(option => {
        return this.matchUrl(option[0]);
      });

      if (filter.length > 0) {
        this.$root.$emit('update-search-url', filter[0]);
      }
    }
  }
};
</script>
