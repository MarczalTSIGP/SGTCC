<template>
  <div>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title font-weight-bold">
          Orientações de TCC 1
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações no Total"
                  :data="data.tcc_one"
                />
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  :title="titleWithCalendar"
                  :data="data.current_tcc_one"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <h3 class="card-title font-weight-bold">
          Orientações de TCC 2
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  title="Orientações no Total"
                  :data="data.tcc_two"
                />
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="card">
              <div class="card-body">
                <orientations-chart
                  :title="titleWithCalendar"
                  :data="data.current_tcc_two"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header">
        <h3 class="card-title font-weight-bold">
          Orientações de TCC 2
        </h3>
      </div>
      <div class="card-body">
        <orientations-line-chart
          :data="data.calendar_report"
        />
      </div>
    </div>
  </div>
</template>

<script>

import OrientationsChart from './orientations-chart';
import OrientationsLineChart from './orientations-line-chart';

export default {
  name: 'OrientationsReport',

  components: {
    OrientationsChart,
    OrientationsLineChart
  },

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
