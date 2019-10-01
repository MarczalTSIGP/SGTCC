<template>
  <div>
    <select-calendars-by-year
      :years="years"
      :path="path"
    />
    <orientations-in-progress-infos />
  </div>
</template>

<script>

import OrientationsInProgressInfos from './orientations-in-progress-infos';
import SelectCalendarsByYear from './select-calendars-by-year';

export default {
  name: 'OrientationsInProgressPage',

  components: {
    OrientationsInProgressInfos,
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
