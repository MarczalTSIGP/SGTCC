<template>
  <div class="form-group page_fa_icon">
    <label
      for="page_fa_icon"
      class="form-control-label url required"
    >
      <strong>Ícone do fontawesome</strong>
    </label>

    <input
      id="page_fa_icon"
      ref="picker"
      v-model="search"
      type="text"
      :class="inputClass"
      name="page[fa_icon]"
      @blur="blur"
      @focus="focus"
    >
    <div
      v-if="focusOn"
      class="preview-container"
    >
      <div
        :class="['previewer', 'rounded', {'custom-shadow-sm': !hoverPanel}, {'custom-shadow': hoverPanel} ]"
        @click="select(undefined)"
        @mouseover="hoverPanel = true"
        @mouseout="hoverPanel = false"
      >
        <div
          v-for="(i, index) in iconsFiltered"
          :key="index"
          class="icon-preview"
        >
          <div
            :class="['icon-wrapper','rounded','shadow-sm', {selected: i.title == selected}]"
            @click.prevent.stop="select(i)"
          >
            <i :class="i.title" />
          </div>
        </div>
      </div>
    </div>
    <div
      v-show="hasErrors()"
      class="invalid-feedback d-block"
    >
      <p
        v-for="(error, index) in errors"
        :key="index"
      >
        {{ error }}
      </p>
    </div>
  </div>
</template>

<script>

import icons from './icons';
let timeout = undefined;

export default {
  name: 'FontawesomePicker',

  props: {
    icon: {
      type: String,
      required: false,
      default() {
        return '';
      },
    },

    errors: {
      type: Array,
      required: false,
      default() {
        return '';
      }
    },
  },

  data() {
    return {
      focusOn: false,
      icons: icons,
      hoverPanel: false,
      search: '',
      beforeSelect: '',
      selected: '',
      value: '',
    };
  },

  computed: {
    iconsFiltered() {
      const search = (this.search == this.selected) ? this.beforeSelect : this.search;

      return this.icons.filter((i) => {
        return i.title.indexOf(search) !== -1 || i.searchTerms.some((t) => {
          return t.indexOf(search) !== -1;
        });
      });
    },

    inputClass() {
      const baseClass = 'form-control';

      if (this.emptyErrors()) {
        return baseClass;
      }

      return `${baseClass} ${this.inputErrorClass()}`;
    },
  },

  watch: {
    search(newValue) {
      this.$emit('input', newValue);
    }
  },

  beforeMount(){
    this.value = this.icon !== null ? this.icon : '';
    this.search = this.value;
  },

  methods: {
    blur() {
      timeout = setTimeout(() => {
        this.focusOn = false;
      }, 150);
    },

    focus(){
      this.focusOn = true;
    },

    select(icon){
      clearTimeout(timeout);
      if (icon) {
        if(this.search != this.selected) {
          this.beforeSelect = this.search;
        }

        this.selected = icon.title;
        this.search = icon.title;
      }
      this.$refs.picker.focus();
    },

    emptyErrors() {
      return this.errors.length === 0;
    },

    hasErrors() {
      return this.errors.length > 0;
    },

    inputErrorClass() {
      return this.hasErrors() ? 'is-invalid' : 'valid';
    },
  },
};

</script>
