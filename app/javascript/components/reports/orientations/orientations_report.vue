<template>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">
        Número de orientações
      </h3>
      <div class="card-options">
        <a
          href="#"
          class="btn btn-primary btn-sm"
        >
          TCC 1 - Geral
        </a>
        <a
          href="#"
          class="btn btn-secondary btn-sm ml-2"
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
            url="teste"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Aprovadas"
            badge-type="success"
            url="teste"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Renovadas"
            badge-type="warning"
            url="teste"
          />
        </div>

        <div class="col-3">
          <orientations-number
            label="Canceladas"
            badge-type="danger"
            url="teste"
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
};

</script>
