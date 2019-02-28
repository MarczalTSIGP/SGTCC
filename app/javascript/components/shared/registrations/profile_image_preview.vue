<template>
  <div>
    <div
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
          <div :class="`form-group file optional ${inputId} form-group-${profileImageClass}`">
            <input
              :id="inputId"
              :class="`form-control-file is-${profileImageClass} file optional`"
              accept="image/*"
              type="file"
              :name="inputName"
              @change="previewImage"
            >
            <div
              v-if="profileImageHasErrors()"
              class="invalid-feedback d-block"
            >
              <p
                v-for="(profileImageError, index) in profileImageErrors"
                :key="index"
              >
                {{ profileImageError }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="text-box text-center">
        <p class="text-input">
          {{ $t('messages.registration.edit_image') }}
        </p>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    profileImageUrl: {
      type: String,
      required: true
    },

    profileImageErrors: {
      type: Array,
      required: true
    },

    resource: {
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
      return `${this.resource}_profile_image`;
    },

    inputName() {
      return `${this.resource}[profile_image]`;
    },

    profileImageClass() {
      return this.profileImageHasError ? 'invalid' : 'valid';
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

    profileImageHasErrors() {
      return this.profileImageErrors.length > 0;
    },

    updateImageData() {
      this.imageData = this.profileImageUrl;
    },
  },
};
</script>
