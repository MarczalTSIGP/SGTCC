<template>
  <div>
    <professors-number
      url="/responsible/professors/total/available"
      label="Disponíveis para orientação"
      redirect="/responsible/professors/available"
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
