<template>
  <span
    data-toggle="tooltip"
    :title="label"
  >
    <span :class="badgeClass">
      <span :style="textColor">
        -
      </span>
    </span>
  </span>
</template>

<script>

export default {
  name: 'ExaminationBoardStatus',

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
      badgeType: 'default',
    };
  },

  computed: {
    textColor() {
      switch (this.badgeType) {
      case 'primary': return { color: '#467fcf' };
      case 'warning': return { color: '#f1c40f' };
      }

      return { color: '#e9ecef' };
    },

    badgeClass() {
      return `badge badge-pill badge-${this.badgeType}`;
    },
  },

  beforeMount() {
    this.setBadgeType();
  },

  methods: {
    setBadgeType() {
      switch(this.status) {
      case 'today':
        this.badgeType = 'primary';
        break;
      case 'next' :
        this.badgeType = 'warning';
      }
    },
  },
};

</script>
