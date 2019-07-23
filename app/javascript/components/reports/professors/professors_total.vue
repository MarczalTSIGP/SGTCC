<template>
  <div>
    <professors-number
      url="/responsible/professors/total"
      label="Cadastrados no SGTCC"
      redirect="/responsible/professors"
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
