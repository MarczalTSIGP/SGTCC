<template>
  <div>
    <select-calendars-by-year
      :years="years"
      :path="path"
    />
    <orientations-infos />
  </div>
</template>

<script>

import OrientationsInfos from './orientations-infos';
import SelectCalendarsByYear from './select-calendars-by-year';

export default {
  name: 'OrientationsPage',

  components: {
    OrientationsInfos,
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
