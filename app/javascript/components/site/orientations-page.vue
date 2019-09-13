<template>
  <div>
    <select-calendars-by-year
      :years="years"
      :path="path"
    />
    <orientations-tables />
  </div>
</template>

<script>

import OrientationsTables from './orientations-tables';
import SelectCalendarsByYear from './select-calendars-by-year';

export default {
  name: 'OrientationsPage',

  components: {
    OrientationsTables,
    SelectCalendarsByYear
  },

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
};

</script>
