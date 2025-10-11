import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    status: String,
    label: String,
  };

  connect() {
    this.setBadgeType();
    this.updateBadge();
  }

  setBadgeType() {
    switch (this.statusValue) {
      case "today":
        this.badgeType = "today";
        this.textColor = "#0b9b1e";
        break;
      case "next":
        this.badgeType = "minutes";
        this.textColor = "#cccc0e";
        break;
      default:
        this.badgeType = "passad";
        this.textColor = "#c1c1c1";
    }
  }

  updateBadge() {
    this.badgeTarget.className = `badge badge-pill badge-${this.badgeType}`;
    this.textTarget.style.color = this.textColor;
    this.textTarget.textContent = "-";
    this.element.setAttribute("title", this.labelValue);
  }

  static targets = ["badge", "text"];
}
