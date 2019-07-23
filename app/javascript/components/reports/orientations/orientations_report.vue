<template>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">
        Número de orientações
      </h3>
      <div class="card-options">
        <a
          href="#"
          :class="totalTccOneButtonClass"
          @click.prevent="updateTccOne()"
        >
          TCC 1 - Geral
        </a>
        <a
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
        <div class="col-3">
          <orientations-number
            label="Em andamento"
            badge-type="primary"
            :url="totalUrl"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Aprovadas"
            badge-type="success"
            :url="totalApprovedUrl"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Renovadas"
            badge-type="warning"
            :url="totalRenewedUrl"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Canceladas"
            badge-type="danger"
            :url="totalCanceledUrl"
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
    totalUrl() {
      return `${this.url}/${this.tcc}/total`;
    },

    totalApprovedUrl() {
      return `${this.totalUrl}/approved`;
    },

    totalRenewedUrl() {
      return `${this.totalUrl}/renewed`;
    },

    totalCanceledUrl() {
      return `${this.totalUrl}/canceled`;
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
