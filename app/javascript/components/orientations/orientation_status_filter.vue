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
        Selecione um Status
      </option>
      <option
        v-for="(option, index) in options"
        :key="index"
        :value="option[0]"
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

  methods: {
    filterByStatus(status) {
      this.$root.$emit('search-term', status);
    },
  },
};
</script>
