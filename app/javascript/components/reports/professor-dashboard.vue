<template>
  <div>
    <professors-orientations-report :professor-id="professorId" />
  </div>
</template>

<script>

import ProfessorsOrientationsReport from './professors/professors-orientations-report';

export default {
  name: 'ProfessorDashboard',

  components: { ProfessorsOrientationsReport },

  props: {
    professorId: {
      type: Number,
      required: true
    },
  },
};

</script>
