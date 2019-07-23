<template>
  <div>
    <professors-number
      number="25"
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
