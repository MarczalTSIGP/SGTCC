<template>
  <div>
    <span :class="badgeClass">
      {{ statusLabel }}
    </span>
  </div>
</template>

<script>
export default {
  name: 'DocumentStatus',

  props: {
    request: {
      type: Object,
      required: false,
      default() {
        return {};
      },
    },
  },

  data() {
    return {
      statusLabel: 'Em análise',
      badgeStatus: 'primary',
    };
  },

  computed: {
    badgeClass() {
      return `badge badge-${this.badgeStatus}`;
    },
  },

  mounted() {
    this.setBadgeStatus();
  },

  methods: {
    hasJudgment() {
      return typeof this.request['judgment'] === 'object';
    },

    setBadgeStatus() {
      if (this.hasJudgment()) {
        this.updateBadgeStatus(this.request.judgment.responsible.accept);
      }
    },

    updateBadgeStatus(value) {
      switch(value) {
      case ('true'):
        this.badgeStatus = 'success';
        this.statusLabel = 'Deferido';
        break;
      case ('false'):
        this.badgeStatus = 'danger';
        this.statusLabel = 'Indeferido';
        break;
      }
    },
  },
};
</script>
