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
    date: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      badgeType: 'default',
      label: 'Ocorreu',
      examinationDate: '',
      dateNow: '',
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

  created() {
    this.updateDates();
    this.setBadgeType();
  },

  methods: {
    setBadgeType() {
      if (this.examinationDate === this.dateNow) {
        this.badgeType = 'primary';
        this.label = 'Hoje';
      } else if (this.examinationDate > this.dateNow) {
        this.badgeType = 'warning';
        this.label = 'Próxima';
      }
    },

    updateDates() {
      this.examinationDate = new Date(this.date).toLocaleDateString();
      this.dateNow = new Date(Date.now()).toLocaleDateString();
    },
  },

};

</script>
