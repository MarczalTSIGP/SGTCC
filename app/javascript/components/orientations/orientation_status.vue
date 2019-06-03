<template>
  <div>
    <span :class="badgeClass">
      {{ statusLabel }}
    </span>
  </div>
</template>

<script>
export default {
  name: 'OrientationStatus',

  props: {
    status: {
      type: String,
      required: true
    },

    label: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      badgeStatus: '',
      statuses: {
        RENEWED: 'warning',
        APPROVED: 'success',
        CANCELED: 'danger',
        IN_PROGRESS: 'primary'
      },
      statusLabel: '',
    };
  },

  computed: {
    badgeClass() {
      return `badge badge-${this.badgeStatus}`;
    },
  },

  mounted() {
    this.setStatusLabel();
    this.setBadgeStatus();
    this.onChangeStatus();
  },

  methods: {
    getBadgeClass(status) {
      return this.statuses[status];
    },

    setStatusLabel() {
      this.statusLabel = this.label;
    },

    setBadgeStatus() {
      this.badgeStatus = this.getBadgeClass(this.status);
    },

    onChangeStatus() {
      this.$root.$on('update-status', (status) => {
        this.badgeStatus = this.getBadgeClass(status.enum);
        this.statusLabel = status.label;
      });
    },
  },
};
</script>
