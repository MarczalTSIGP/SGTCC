<template>
  <div>
    <professors-number
      url="/responsible/professors/total/unavailable"
      label="Indisponíveis para orientação"
      redirect="/responsible/professors/unavailable"
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
