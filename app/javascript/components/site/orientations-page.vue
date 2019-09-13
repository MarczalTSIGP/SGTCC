<template>
  <div>
    <select-calendars-by-year
      :years="years"
      :path="path"
    />
    <orientations-table :data="data" />
  </div>
</template>

<script>

import OrientationsTable from './orientations-table';
import SelectCalendarsByYear from './select-calendars-by-year';

export default {
  name: 'OrientationsPage',

  components: {
    OrientationsTable,
    SelectCalendarsByYear
  },

  props: {
    data: {
      type: Array,
      required: true
    },

    years: {
      type: Array,
      required: true
    },

    path: {
      type: String,
      required: true
    },
  },
};

</script>
