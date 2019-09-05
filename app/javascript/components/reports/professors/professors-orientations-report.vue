<template>
  <div>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title font-weight-bold">
          Orientações
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações de TCC 1 no Total"
                  :data="data.tcc_one"
                />
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações de TCC 2 no Total"
                  :data="data.tcc_two"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsChart from '../orientations/orientations_chart';

export default {
  name: 'ProfessorsOrientationsReport',

  components: { OrientationsChart },

  props: {
    data: {
      type: Object,
      required: true
    },
  },

  computed: {
    titleWithCalendar() {
      return `Orientações em (${this.data.calendar})`;
    },
  },
};

</script>
