// app/javascript/controllers/markdown_reader_controller.js
import { Controller } from "@hotwired/stimulus";
import { marked } from "marked";

export default class extends Controller {
  static values = { content: String };

  connect() {
    this.renderMarkdown();
  }

  contentValueChanged() {
    this.renderMarkdown();
  }

  renderMarkdown() {
    if (!this.hasContentValue) return;

    const html = marked.parse(this.contentValue);
    this.element.innerHTML = html;
  }
}
