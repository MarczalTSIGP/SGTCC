<template>
  <div class="container">
    <div class="row">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <orientations-chart
              title="Orientações de TCC 1 - Geral"
              :data="data.tcc_one"
            />
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <orientations-chart
              title="Orientações de TCC 2 - Geral"
              :data="data.tcc_two"
            />
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <orientations-chart
              title="Orientações de TCC 1 - Período atual"
              :data="data.current_tcc_one"
            />
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="card">
          <div class="card-body">
            <orientations-chart
              title="Orientações de TCC 2 - Período atual"
              :data="data.current_tcc_two"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsChart from './orientations_chart';

export default {
  name: 'OrientationsReport',

  components: { OrientationsChart },

  props: {
    data: {
      type: Object,
      required: true
    },
  },
};

</script>
