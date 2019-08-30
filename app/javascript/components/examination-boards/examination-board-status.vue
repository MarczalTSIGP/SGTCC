<template>
  <span :class="badgeClass">{{ label }}</span>
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
    badgeClass() {
      return `badge badge-${this.badgeType}`;
    },
  },

  mounted() {
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
