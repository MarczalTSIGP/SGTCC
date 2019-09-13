<template>
  <div class="row">
    <div class="col-md-6">
      <card-report-number
        label="Em andamento"
        background-color="primary"
        :number="report.in_progress"
        :title="title"
      />
    </div>

    <div class="col-md-6">
      <card-report-number
        label="Aprovadas"
        background-color="success"
        :number="report.approved"
        :title="title"
      />
    </div>
  </div>
</template>

<script>

import CardReportNumber from '../card-report-number';

export default {
  name: 'ProfessorsTotalOrientationsReport',

  components: {
    CardReportNumber
  },

  props: {
    report: {
      type: Object,
      required: true
    },

    title: {
      type: String,
      required: true
    },
  },
};

</script>
