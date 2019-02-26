<template>
  <div>
    <transition name="fade">
      <div
        v-for="(message, index) in messages"
        v-show="show"
        :key="index"
        :class="getAlertClass(message, index)"
        role="alert"
      >
        <button
          class="close"
          data-dismiss="alert"
          aria-label="Close"
        />
        {{ message[index + 1] }}
      </div>
    </transition>
  </div>
</template>

<script>

export default {
  name: 'FlashMessages',

  props: {
    messages: {
      type: Array,
      default() {
        return [];
      },
    },
  },

  data() {
    return {
      show: true,
      types: {
        'error': 'danger',
        'alert': 'warning',
        'notice': 'info',
        'success': 'success'
      },
    };
  },

  mounted() {
    this.fadeOutMessage();
  },

  methods: {
    getAlertClass(message, index) {
      const type = this.types[message[index]];

      return `alert alert-${type} alert-dismissible`;
    },

    fadeOutMessage() {
      const tenSeconds = 10000;

      setTimeout(() => {
        this.show = false;
      }, tenSeconds);
    },
  },
};

</script>

<style scoped>

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}

</style>
