<template>
  <div>
    <professors-number
      url="/responsible/professors/available"
      label="Disponíveis para orientação"
      background-color="green"
    />
  </div>
</template>

<script>

import ProfessorsNumber from './professors_number';

export default {
  name: 'ProfessorsAvailable',

  components: { ProfessorsNumber },
};

</script>
