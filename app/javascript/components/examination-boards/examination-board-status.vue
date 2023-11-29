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
      badgeType: 'passad',
    };
  },

  computed: {
    textColor() {
      switch (this.badgeType) {
      case 'today': return { color: '#0b9b1e' };
      case 'minutes': return { color: '#cccc0e' };
      }

      return { color: '#c1c1c1' };
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
        this.badgeType = 'today';
        break;
      case 'next' :
        this.badgeType = 'minutes';
      }
    },
  },
};

</script>
