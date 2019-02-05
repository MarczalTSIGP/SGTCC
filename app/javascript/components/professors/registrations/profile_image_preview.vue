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
          <div :class="`form-group file optional professor_profile_image form-group-${profileImageClass}`">
            <input
              id="professor_profile_image"
              :class="`form-control-file is-${profileImageClass} file optional`"
              accept="image/*"
              type="file"
              name="professor[profile_image]"
              @change="previewImage"
            >
            <div
              v-if="profileImageHasErrors()"
              class="invalid-feedback d-block"
            >
              <p v-for="profileImageError in profileImageErrors">
                {{ profileImageError }}
              </p>
            </div>
          </div>
          <input
            id="professor_profile_image_cache"
            type="hidden"
            name="professor[profile_image_cache]"
          >
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
  },

  computed: {
    profileImageClass: function() {
      return this.profileImageHasError ? 'invalid' : 'valid';
    },
  },

  data() {
    return {
      imageData: ''
    };
  },

  mounted() {
    this.imageData = this.profileImageUrl;
    this.profileImageHasErrors();
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
  },
};
</script>
