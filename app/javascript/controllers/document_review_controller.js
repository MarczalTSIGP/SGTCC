import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    documentId: Number,
    hasPermission: Boolean,
    canEdit: Boolean,
  };

  edit() {
    const url = `/documents/${this.documentIdValue}/edit_judgment`;
    Turbo.visit(url, { frame: `document_judgment_${this.documentIdValue}` });
  }
}
