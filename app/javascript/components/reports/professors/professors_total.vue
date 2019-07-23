<template>
  <div>
    <professors-number
      url="/responsible/professors/total"
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
