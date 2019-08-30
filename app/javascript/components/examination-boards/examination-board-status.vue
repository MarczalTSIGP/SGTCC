<template>
  <div>
    <span :class="badgeClass">
      <span :style="textColor">
        -
      </span>
    </span>
    <span
      class="float-left ml-2"
      :style="labelStyle"
    >
      {{ label }}
    </span>
  </div>
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
      labelStyle: { marginTop: '0.5px' },
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
      return `float-left mt-1 badge badge-pill badge-${this.badgeType}`;
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
