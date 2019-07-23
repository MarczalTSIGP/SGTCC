<template>
  <div class="row">
    <div class="col-md-4 col-sm-12">
      <professors-total />
    </div>

    <div class="col-md-4 col-sm-12">
      <professors-available />
    </div>

    <div class="col-md-4 col-sm-12">
      <professors-unavailable />
    </div>
  </div>
</template>

<script>

import ProfessorsAvailable from './professors/professors_available';
import ProfessorsUnavailable from './professors/professors_unavailable';
import ProfessorsTotal from './professors/professors_total';

export default {
  name: 'ResponsibleDashboard',

  components: {
    ProfessorsAvailable,
    ProfessorsUnavailable,
    ProfessorsTotal
  },
};

</script>
