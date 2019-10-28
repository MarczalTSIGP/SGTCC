<template>
  <div>
    <checkbox-view
      id="meeting_viewed"
      name="meeting[viewed]"
      :url="url"
      :value="value"
      :confirmation-message="confirmMessage"
      :success-message="successMessage"
    />
  </div>
</template>

<script>

import CheckboxView from '../../shared/checkbox-view';

export default {
  name: 'MeetingView',

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
      confirmMessage: 'Você tem certeza que deseja dar ciência nessa reunião?',
      successMessage: 'Reunião atualizada com sucesso!',
    };
  },
};

</script>
