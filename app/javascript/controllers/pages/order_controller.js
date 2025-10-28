import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";
import swal from "sweetalert";

export default class extends Controller {
  static targets = ["list", "updateButton"];
  static values = {
    sidebarUrl: String,
    updateUrl: String
  };

  connect() {
    this.pages = [];
    this.isDragging = false;
    this.loadPages();
  }

  async loadPages() {
    try {
      const response = await fetch(this.sidebarUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken()
        }
      });

      if (!response.ok) {
        throw new Error("Erro ao carregar páginas");
      }

      this.pages = await response.json();
      this.renderPages();
      this.initializeSortable();
      this.checkButtonState();
    } catch (error) {
      console.error("Erro ao carregar páginas:", error);
      this.showError("Erro ao carregar as páginas");
    }
  }

  renderPages() {
    if (this.pages.length === 0) {
      this.listTarget.innerHTML = `
        <li class="list-group-item text-center text-muted">
          Nenhuma página encontrada
        </li>
      `;
      return;
    }

    this.listTarget.innerHTML = this.pages.map(page => `
      <li class="list-group-item list-group-item-action" data-page-id="${page.id}">
        <span class="icon mr-3">
          <i class="${page.fa_icon}"></i>
        </span>
        ${page.menu_title}
        <i class="ml-3 fa fa-list-ul" style="font-size: 8px;"></i>
      </li>
    `).join("");
  }

  initializeSortable() {
    if (this.sortable) {
      this.sortable.destroy();
    }

    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      handle: "li",
      draggable: "li",
      onStart: () => {
        this.isDragging = true;
      },
      onEnd: () => {
        this.isDragging = false;
        this.updatePagesOrder();
      }
    });
  }

  updatePagesOrder() {
    const items = Array.from(this.listTarget.querySelectorAll("li"));
    const newOrder = items.map(item => {
      const pageId = parseInt(item.dataset.pageId);
      return this.pages.find(page => page.id === pageId);
    }).filter(Boolean);

    this.pages = newOrder;
  }

  async updateOrder() {
    if (this.pages.length <= 1) {
      this.showWarning("É necessário ter pelo menos 2 páginas para reordenar");
      return;
    }

    const data = {
      data: this.pages.map(page => ({ id: page.id }))
    };

    try {
      const response = await fetch(this.updateUrlValue, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken()
        },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        throw new Error("Erro ao atualizar ordem");
      }

      const result = await response.json();
      
      if (result) {
        this.showSuccess("Menu atualizado com sucesso!");
      }
    } catch (error) {
      console.error("Erro ao atualizar ordem:", error);
      this.showError("Erro ao atualizar o menu");
    }
  }

  checkButtonState() {
    if (this.hasUpdateButtonTarget) {
      this.updateButtonTarget.disabled = this.pages.length <= 1;
    }
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy();
    }
  }

  csrfToken() {
    const meta = document.querySelector("meta[name=\"csrf-token\"]");
    return meta ? meta.content : "";
  }

  showSuccess(message) {
    swal("", message, "success");
  }

  showError(message) {
    swal("", message, "error");
  }

  showWarning(message) {
    swal("", message, "warning");
  }
}

