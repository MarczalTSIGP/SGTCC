<template>
  <div>
    <div id="box-image-preview"
         data-toggle="tooltip"
         data-placement="left"
         :title="$t('messages.registration.edit_image')">

      <div class="input-field image_preview">
        <div class="box-image center">
          <img class="file_preview active" :src="imageData">
            <div class="form-group file optional professor_profile_image form-group-valid">
              <input class="form-control-file is-valid file optional"
                     accept="image/*"
                     type="file"
                     name="professor[profile_image]"
                     id="professor_profile_image"
                     @change="previewImage">
            </div>
        </div>
      </div>
    </div>

    <div class="text-box text-center">
      <p class="text-input">{{ $t('messages.registration.edit_image') }}</p>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    profileImageUrl: {
      type: String,
      required: true
    }
  },

  data() {
    return {
      imageData: ''
    };
  },

  mounted() {
    this.imageData = this.profileImageUrl;
  },

  methods: {
    previewImage(event) {
      let input = event.target;

      if (input.files && input.files[0]) {
        let render = new FileReader();

        render.onload = (e) => {
          this.imageData = e.target.result;
        }

        render.readAsDataURL(input.files[0]);
      }
    },
  },
}
</script>


