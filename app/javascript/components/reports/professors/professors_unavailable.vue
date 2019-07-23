<template>
  <div>
    <professors-number
      url="/responsible/professors/unavailable"
      label="Indisponíveis para orientação"
      background-color="red"
    />
  </div>
</template>

<script>

import ProfessorsNumber from './professors_number';

export default {
  name: 'ProfessorsUnavailable',

  components: { ProfessorsNumber },
};

</script>
