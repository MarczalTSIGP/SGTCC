<template>
  <div class="float-right">
    <p :style="{ 'margin-top': 50 + 'px', 'margin-bottom': 50 + 'px' }">
      Guarapuava, {{ createdAt }}.
    </p>
  </div>
</template>

<script>
export default {
  name: 'TermFooter',

  props: {
    createdAt: {
      type: String,
      required: true
    },
  },
};
</script>
