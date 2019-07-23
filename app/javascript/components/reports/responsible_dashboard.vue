<template>
  <div class="row">
    <div class="col-4">
      <professors-total />
    </div>

    <div class="col-4">
      <professors-available />
    </div>

    <div class="col-4">
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
