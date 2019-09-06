<template>
  <div class="row">
    <div class="col-md-4 col-sm-12">
      <card-report-number
        label="Cadastrados no SGTCC"
        background-color="primary"
        :number="professors.total"
        :title="title"
        redirect="/responsible/professors"
      />
    </div>

    <div class="col-md-4 col-sm-12">
      <card-report-number
        label="Disponíveis para orientação"
        background-color="green"
        :number="professors.available"
        :title="title"
        redirect="/responsible/professors/available"
      />
    </div>

    <div class="col-md-4 col-sm-12">
      <card-report-number
        label="Indisponíveis para orientação"
        background-color="red"
        :number="professors.unavailable"
        :title="title"
        redirect="/responsible/professors/unavailable"
      />
    </div>
  </div>
</template>

<script>

import CardReportNumber from '../card-report-number';

export default {
  name: 'ProfessorsReport',

  components: {
    CardReportNumber
  },

  props: {
    professors: {
      type: Object,
      required: true
    },
  },

  data() {
    return {
      title: 'Professores',
    };
  },
};

</script>
