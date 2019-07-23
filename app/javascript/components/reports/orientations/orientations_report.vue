<template>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">
        Número de orientações
      </h3>
      <div class="card-options">
        <a
          id="tcc_one_geral"
          href="#"
          :class="totalTccOneButtonClass"
          @click.prevent="updateTccOne()"
        >
          TCC 1 - Geral
        </a>
        <a
          id="tcc_two_geral"
          href="#"
          :class="totalTccTwoButtonClass"
          @click.prevent="updateTccTwo()"
        >
          TCC 2 - Geral
        </a>
      </div>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-3 col-sm-12">
          <orientations-number
            label="Em andamento"
            badge-type="primary"
            :url="totalUrl"
            :redirect="baseUrl"
          />
        </div>

        <div class="col-md-3 col-sm-12">
          <orientations-number
            label="Aprovadas"
            badge-type="success"
            :url="totalApprovedUrl"
            :redirect="redirectAprrovedUrl"
          />
        </div>

        <div class="col-md-3 col-sm-12">
          <orientations-number
            label="Renovadas"
            badge-type="warning"
            :url="totalRenewedUrl"
            :redirect="redirectRenewedUrl"
          />
        </div>

        <div class="col-md-3 col-sm-12">
          <orientations-number
            label="Canceladas"
            badge-type="danger"
            :url="totalCanceledUrl"
            :redirect="redirectCanceledUrl"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsNumber from './orientations_number';

export default {
  name: 'OrientationsReport',

  components: { OrientationsNumber },

  data() {
    return {
      tcc: 'tcc_one',
      tccOneButtonType: 'primary',
      tccTwoButtonType: 'secondary',
      url: '/responsible/orientations'
    };
  },

  computed: {
    baseUrl() {
      return `${this.url}/${this.tcc}`;
    },

    totalUrl() {
      return `${this.baseUrl}/total`;
    },

    totalApprovedUrl() {
      return `${this.totalUrl}/approved`;
    },

    redirectAprrovedUrl() {
      return `${this.baseUrl}/APPROVED/search`;
    },

    totalRenewedUrl() {
      return `${this.totalUrl}/renewed`;
    },

    redirectRenewedUrl() {
      return `${this.baseUrl}/RENEWED/search`;
    },

    totalCanceledUrl() {
      return `${this.totalUrl}/canceled`;
    },

    redirectCanceledUrl() {
      return `${this.baseUrl}/CANCELED/search`;
    },

    totalTccOneButtonClass() {
      return `btn btn-${this.tccOneButtonType} btn-sm`;
    },

    totalTccTwoButtonClass() {
      return `btn btn-${this.tccTwoButtonType} btn-sm ml-2`;
    },
  },

  methods: {
    updateTccOne() {
      this.tcc = 'tcc_one';
      this.tccOneButtonType = 'primary';
      this.tccTwoButtonType = 'secondary';
    },

    updateTccTwo() {
      this.tcc = 'tcc_two';
      this.tccTwoButtonType = 'primary';
      this.tccOneButtonType = 'secondary';
    },
  },
};

</script>
