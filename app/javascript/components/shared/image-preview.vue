<template>
  <div>
    <div
      v-show="imageData"
      id="box-image-preview"
      data-toggle="tooltip"
      data-placement="left"
      :title="$t('messages.registration.edit_image')"
    >
      <div class="input-field image_preview">
        <div class="box-image center">
          <img
            class="file_preview active"
            :src="imageData"
          >
          <div class="form-group file optional form-group">
            <input
              :id="inputId"
              :class="`form-control-file is-${imageClass} file optional`"
              accept="image/*"
              type="file"
              :name="inputName"
              @change="previewImage"
            >
          </div>
        </div>
      </div>

      <div class="text-box text-center">
        <p class="text-input">
          {{ $t('messages.registration.edit_image') }}
        </p>
      </div>
    </div>
    <div
      v-show="!imageData"
    >
      <label>
        <strong>Imagem *</strong>
      </label>

      <div class="custom-file">
        <input
          :id="inputId"
          class="custom-file-input"
          accept="image/*"
          type="file"
          :name="inputName"
          @change="previewImage"
        >
        <label class="custom-file-label">Selecionar imagem</label>
      </div>
    </div>
    <div
      v-if="imageHasErrors()"
      class="invalid-feedback d-block"
      :class="inputId"
    >
      <p
        v-for="(error, index) in imageErrors"
        :key="index"
      >
        {{ 'Imagem' + ' ' + error }}
      </p>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    imageUrl: {
      type: String,
      required: false,
      default() {
        return null;
      }
    },

    imageErrors: {
      type: Array,
      required: true
    },

    resource: {
      type: String,
      required: true
    },

    name: {
      type: String,
      required: true
    },
  },

  data() {
    return {
      imageData: ''
    };
  },

  computed: {
    inputId() {
      return `${this.resource}_${this.name}`;
    },

    inputName() {
      return `${this.resource}[${this.name}]`;
    },

    imageClass() {
      return this.imageHasErrors() ? 'invalid' : 'valid';
    },
  },

  mounted() {
    this.updateImageData();
  },

  methods: {
    previewImage(event) {
      let input = event.target;

      if (input.files && input.files[0]) {
        let render = new FileReader();

        render.onload = (e) => {
          this.imageData = e.target.result;
        };

        render.readAsDataURL(input.files[0]);
      }
    },

    imageHasErrors() {
      return this.imageErrors.length > 0;
    },

    updateImageData() {
      this.imageData = this.imageUrl;
    },
  },
};
</script>
