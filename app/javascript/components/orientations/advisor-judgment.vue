<template>
  <div>
    <checkbox-view
      id="academic_activity_judgment"
      name="academic_activity[judgment]"
      :url="url"
      :value="value"
      :confirmation-message="confirmMessage"
      :success-message="successMessage"
    />
  </div>
</template>

<script>

import CheckboxView from '../shared/checkbox-view';

export default {
  name: 'AdvisorJudgment',

  components: { CheckboxView },

  props: {
    url: {
      type: String,
      required: true
    },

    value: {
      type: Boolean,
      required: true
    },
  },

  data() {
    return {
      confirmMessage: 'Você tem certeza que deseja dar ciência nessa atividade?',
      successMessage: 'Atividade atualizada com sucesso!',
    };
  },
};

</script>
