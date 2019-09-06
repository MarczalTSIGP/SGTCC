<template>
  <div class="row">
    <div class="col-md-3 col-sm-12">
      <card-report-number
        label="Cadastrados no SGTCC"
        background-color="default"
        :number="academics.total"
        :title="title"
        redirect="/responsible/academics"
      />
    </div>

    <div class="col-md-3 col-sm-12">
      <card-report-number
        label="Com orientações em andamento"
        background-color="primary"
        :number="academics.orientations.all.in_progress"
        :title="title"
        redirect="/responsible/orientations/current_tcc_one"
      />
    </div>

    <div class="col-md-3 col-sm-12">
      <card-report-number
        label="Concluíram o TCC 1"
        background-color="lime"
        :number="academics.orientations.tcc_one.approved"
        :title="title"
        redirect="/responsible/orientations/tcc_one/APPROVED/search"
      />
    </div>

    <div class="col-md-3 col-sm-12">
      <card-report-number
        label="Concluíram o TCC 2"
        background-color="green"
        :number="academics.orientations.tcc_two.approved"
        :title="title"
        redirect="/responsible/orientations/tcc_two/APPROVED/search"
      />
    </div>
  </div>
</template>

<script>

import CardReportNumber from '../card-report-number';

export default {
  name: 'AcademicsReport',

  components: {
    CardReportNumber
  },

  props: {
    academics: {
      type: Object,
      required: true
    },
  },

  data() {
    return {
      title: 'Acadêmicos',
    };
  },
};

</script>
