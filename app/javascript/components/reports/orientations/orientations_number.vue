<template>
  <div :class="`card border border-${badgeType}`">
    <div class="card-body text-center">
      <div class="h5">
        {{ label }}
      </div>
      <div class="display-4 font-weight-bold mb-4">
        100
      </div>
      <div class="progress progress-sm">
        <div
          :class="progressBarClass"
          style="width: 100%"
        />
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'OrientationsNumber',

  props: {
    label: {
      type: String,
      required: true
    },

    badgeType: {
      type: String,
      required: true
    },

    url: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      backgroundColor: {
        primary: 'blue',
        danger: 'red',
        warning: 'yellow',
        success: 'green'
      },
    };
  },

  computed: {
    progressBarClass: function() {
      const backgroundColor = this.backgroundColor[this.badgeType];

      return `progress-bar bg-${backgroundColor}`;
    },
  },
};

</script>
