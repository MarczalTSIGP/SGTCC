<template>
  <div>
    <div id="box-image-preview"
         data-toggle="tooltip"
         data-placement="left"
         title="Clique na imagem para alterá-la">

      <div class="input-field image_preview">
        <div class="box-image center">
          <img class="file_preview active" :src="imageSource">
            <div class="form-group file optional professor_profile_image form-group-valid">
              <input class="form-control-file is-valid file optional"
                     accept="image/*"
                     type="file"
                     name="professor[profile_image]"
                     id="professor_profile_image">
            </div>
        </div>
      </div>
    </div>

    <div class="text-box text-center">
      <p class="text-input">Clique na imagem para alterá-la</p>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    imageSource: {
      type: String,
      required: true
    }
  },
}
</script>


