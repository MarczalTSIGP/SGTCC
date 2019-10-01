<template>
  <div>
    <select-calendars-by-year
      :years="years"
      :path="path"
    />
    <orientations-approved-infos />
  </div>
</template>

<script>

import OrientationsApprovedInfos from './orientations-approved-infos';
import SelectCalendarsByYear from './select-calendars-by-year';

export default {
  name: 'OrientationsApprovedPage',

  components: {
    OrientationsApprovedInfos,
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
