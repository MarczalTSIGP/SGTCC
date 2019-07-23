<template>
  <div>
    <professors-number
      number="50"
      label="Cadastrados no SGTCC"
      background-color="primary"
    />
  </div>
</template>

<script>

import ProfessorsNumber from './professors_number';

export default {
  name: 'ProfessorsTotal',

  components: { ProfessorsNumber },
};

</script>
