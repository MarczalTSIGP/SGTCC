<template>
  <div class="form-group">
    <label
      :for="id"
      class="form-control-label string required"
    >
      {{ label }}
      <abbr title="obrigatório">
        *
      </abbr>
    </label>
    <div
      :id="datetimepicker_id"
      class="input-group date"
      data-target-input="nearest"
    >
      <input
        type="text"
        class="form-control datetimepicker-input"
        :data-target="datetimepicker_id_hash"
        :disabled="disabled"
      >
      <div
        class="input-group-append"
        :data-target="datetimepicker_id_hash"
        data-toggle="datetimepicker"
      >
        <div class="input-group-text">
          <i class="fe fe-calendar" />
        </div>
      </div>
    </div>
    <input
      :id="id"
      :value="value"
      type="hidden"
      :name="name"
    >
  </div>
</template>

<script>

import moment from 'moment';

export default {
  name: 'Datetimepicker',

  props: {
    name: {
      type: String,
      required: true
    },

    id: {
      type: String,
      required: true
    },

    label: {
      type: String,
      required: true
    },

    datetime: {
      type: String,
      default() {
        return '';
      }
    },

    disabled: {
      type: Boolean,
      default() {
        return false;
      }
    }
  },

  data() {
    return {
      value: ''
    };
  },

  computed: {
    datetimepicker_id() {
      return `datetimepicker_${this.id}`;
    },

    datetimepicker_id_hash() {
      return `#${this.datetimepicker_id}`;
    }
  },

  mounted() {
    this.setValue();
    this.initDatepicker();
    this.updateValue();
  },

  methods: {
    initDatepicker() {
      const $ = window.jQuery;

      $(this.datetimepicker_id_hash).datetimepicker({
        format: 'DD/MM/YYYY HH:mm',
        icons: {
          time: 'fe fe-clock'
        },
        date: this.value
      });
    },

    setValue() {
      this.value = this.datetime !== ''
        ? moment(this.datetime, 'YYYY-MM-DD HH:mm')
        : moment().format();
    },

    updateValue() {
      const $ = window.jQuery;

      $(this.datetimepicker_id_hash).on('change.datetimepicker', (e) => {
        this.value = moment(e.date).format('DD/MM/YYYY HH:mm');
      });
    },
  },
};

</script>
