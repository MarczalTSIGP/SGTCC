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

    time: {
      type: String,
      require: true
    },

    distanceInWords: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      examinationDate: '',
      badgeType: '',
      dateNow: '',
      label: '',
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

    todayLabel() {
      return `Será hoje às ${this.time}`;
    },

    nextLabel() {
      return `Será em ${this.distanceInWords}`;
    },

    ocurredLabel() {
      return `Ocorreu a ${this.distanceInWords}`;
    },
  },

  created() {
    this.updateDates();
  },

  beforeMount() {
    this.setBadgeType();
  },

  methods: {
    setBadgeType() {
      if (this.examinationDate === this.dateNow) {
        return this.setTodayData();
      }

      return (this.examinationDate > this.dateNow)
        ? this.setNextData()
        : this.setOcurredData();
    },

    setTodayData() {
      this.badgeType = 'primary';
      this.label = this.todayLabel;
    },

    setNextData() {
      this.badgeType = 'warning';
      this.label = this.nextLabel;
    },

    setOcurredData() {
      this.badgeType = 'default';
      this.label = this.ocurredLabel;
    },

    updateDates() {
      const today = new Date(Date.now());
      const date = new Date(this.date);

      this.examinationDate = date.toLocaleDateString();
      this.dateNow = today.toLocaleDateString();
    },
  },

};

</script>
