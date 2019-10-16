<template>
  <div>
    <generate-defense-minutes
      :id="id"
      :url="url"
      :title="title"
      :details="details"
      :color-type="colorType"
      :confirmation-message="confirmationMessage"
    />
  </div>
</template>

<script>

import GenerateDefenseMinutes from './generate-defense-minutes';

export default {
  name: 'GenerateNonAttendanceDefenseMinutes',

  components: { GenerateDefenseMinutes },

  props: {
    url: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      title: 'Gerar Ata de Defesa de não comparecimento do acadêmico',
      details: 'Este documento deve ser gerado quando o acadêmico não compareceu para defender seu TCC.',
      confirmationMessage: `Você tem certeza que deseja gerar a Ata de Defesa de não
       comparecimento do acadêmico?`,
      colorType: 'danger',
      id: 'generate_non_attendance_defense_minutes',
    };
  },
};

</script>
