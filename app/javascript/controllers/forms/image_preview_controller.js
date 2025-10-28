import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image", "previewBox", "uploadBox", "initialInput", "fileLabel"];
  static values = { url: String };

  connect() {
    if (this.hasImageTarget && this.urlValue) {
      this.imageTarget.src = this.urlValue;
    }
  }

  preview(event) {
    const input = event.target;
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = (e) => {
        if (this.hasImageTarget) {
          this.imageTarget.src = e.target.result;
        }
        
        if (this.hasUploadBoxTarget && this.hasPreviewBoxTarget) {
          this.uploadBoxTarget.style.display = "none";
          this.previewBoxTarget.style.display = "block";
        }
        
        this.updateFileLabel(input);
      };
      reader.readAsDataURL(input.files[0]);
    }
  }

  updateFileLabel(input) {
    if (this.hasFileLabelTarget) {
      const fileName = input.files[0]?.name || "Selecionar imagem";
      this.fileLabelTarget.textContent = fileName;
    }
  }
}
