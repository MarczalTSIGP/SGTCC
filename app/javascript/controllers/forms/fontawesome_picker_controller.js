import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "previewContainer", "previewer"];
  static values = { icon: String };

  connect() {
    this.focusOn = false;
    this.hoverPanel = false;
    this.searchTerm = "";
    this.selected = this.iconValue || "";
    this.beforeSelect = "";
    this.blurTimeout = null;
    
    this.icons = [
      { title: "fa-solid fa-house", searchTerms: ["home", "casa", "inicio"] },
      { title: "fa-solid fa-user", searchTerms: ["user", "usuario", "pessoa"] },
      { title: "fa-solid fa-users", searchTerms: ["users", "usuarios", "pessoas", "grupo"] },
      { title: "fa-solid fa-gear", searchTerms: ["settings", "configuracoes", "opcoes"] },
      { title: "fa-solid fa-envelope", searchTerms: ["email", "mail", "mensagem"] },
      { title: "fa-solid fa-phone", searchTerms: ["phone", "telefone", "contato"] },
      { title: "fa-solid fa-calendar", searchTerms: ["calendar", "calendario", "data"] },
      { title: "fa-solid fa-clock", searchTerms: ["clock", "relogio", "hora", "tempo"] },
      { title: "fa-solid fa-file", searchTerms: ["file", "arquivo", "documento"] },
      { title: "fa-solid fa-folder", searchTerms: ["folder", "pasta", "diretorio"] },
      { title: "fa-solid fa-book", searchTerms: ["book", "livro", "leitura"] },
      { title: "fa-solid fa-graduation-cap", searchTerms: ["education", "educacao", "formatura", "estudante"] },
      { title: "fa-solid fa-briefcase", searchTerms: ["work", "trabalho", "maleta"] },
      { title: "fa-solid fa-chart-line", searchTerms: ["chart", "grafico", "estatistica"] },
      { title: "fa-solid fa-chart-bar", searchTerms: ["chart", "grafico", "barras"] },
      { title: "fa-solid fa-chart-pie", searchTerms: ["chart", "grafico", "pizza"] },
      { title: "fa-solid fa-magnifying-glass", searchTerms: ["search", "busca", "procurar", "lupa"] },
      { title: "fa-solid fa-bell", searchTerms: ["notification", "notificacao", "sino", "alerta"] },
      { title: "fa-solid fa-star", searchTerms: ["star", "estrela", "favorito"] },
      { title: "fa-solid fa-heart", searchTerms: ["heart", "coracao", "favorito", "like"] },
      { title: "fa-solid fa-pencil", searchTerms: ["edit", "editar", "lapis", "escrever"] },
      { title: "fa-solid fa-trash", searchTerms: ["delete", "deletar", "lixo", "remover"] },
      { title: "fa-solid fa-plus", searchTerms: ["add", "adicionar", "novo", "criar"] },
      { title: "fa-solid fa-minus", searchTerms: ["remove", "remover", "subtrair"] },
      { title: "fa-solid fa-check", searchTerms: ["check", "confirmar", "ok", "sucesso"] },
      { title: "fa-solid fa-xmark", searchTerms: ["close", "fechar", "cancelar", "x"] },
      { title: "fa-solid fa-circle-info", searchTerms: ["info", "informacao", "ajuda"] },
      { title: "fa-solid fa-circle-exclamation", searchTerms: ["warning", "aviso", "atencao"] },
      { title: "fa-solid fa-circle-check", searchTerms: ["success", "sucesso", "confirmado"] },
      { title: "fa-solid fa-triangle-exclamation", searchTerms: ["warning", "aviso", "perigo"] },
      { title: "fa-solid fa-download", searchTerms: ["download", "baixar", "salvar"] },
      { title: "fa-solid fa-upload", searchTerms: ["upload", "enviar", "carregar"] },
      { title: "fa-solid fa-print", searchTerms: ["print", "imprimir", "impressora"] },
      { title: "fa-solid fa-share", searchTerms: ["share", "compartilhar"] },
      { title: "fa-solid fa-link", searchTerms: ["link", "url", "conexao"] },
      { title: "fa-solid fa-lock", searchTerms: ["lock", "cadeado", "seguro", "privado"] },
      { title: "fa-solid fa-unlock", searchTerms: ["unlock", "aberto", "desbloquear"] },
      { title: "fa-solid fa-eye", searchTerms: ["view", "ver", "visualizar", "olho"] },
      { title: "fa-solid fa-eye-slash", searchTerms: ["hide", "ocultar", "esconder"] },
      { title: "fa-solid fa-image", searchTerms: ["image", "imagem", "foto"] },
      { title: "fa-solid fa-video", searchTerms: ["video", "filme"] },
      { title: "fa-solid fa-music", searchTerms: ["music", "musica", "audio"] },
      { title: "fa-solid fa-comment", searchTerms: ["comment", "comentario", "mensagem"] },
      { title: "fa-solid fa-comments", searchTerms: ["comments", "comentarios", "chat"] },
      { title: "fa-solid fa-location-dot", searchTerms: ["location", "localizacao", "mapa", "pin"] },
      { title: "fa-solid fa-globe", searchTerms: ["world", "mundo", "global", "internet"] },
      { title: "fa-solid fa-wifi", searchTerms: ["wifi", "wireless", "internet"] },
      { title: "fa-solid fa-database", searchTerms: ["database", "banco de dados", "dados"] },
      { title: "fa-solid fa-server", searchTerms: ["server", "servidor"] },
      { title: "fa-solid fa-code", searchTerms: ["code", "codigo", "programacao"] },
      { title: "fa-solid fa-terminal", searchTerms: ["terminal", "console", "cmd"] },
      { title: "fa-solid fa-bug", searchTerms: ["bug", "erro", "problema"] },
      { title: "fa-solid fa-shield", searchTerms: ["security", "seguranca", "protecao"] },
      { title: "fa-solid fa-key", searchTerms: ["key", "chave", "senha"] },
      { title: "fa-solid fa-award", searchTerms: ["award", "premio", "medalha"] },
      { title: "fa-solid fa-trophy", searchTerms: ["trophy", "trofeu", "vencedor"] },
      { title: "fa-solid fa-flag", searchTerms: ["flag", "bandeira", "marcador"] },
      { title: "fa-solid fa-bookmark", searchTerms: ["bookmark", "marcador", "favorito"] },
      { title: "fa-solid fa-thumbs-up", searchTerms: ["like", "curtir", "positivo"] },
      { title: "fa-solid fa-thumbs-down", searchTerms: ["dislike", "negativo"] },
      { title: "fa-solid fa-power-off", searchTerms: ["power", "desligar", "sair"] },
      { title: "fa-solid fa-right-from-bracket", searchTerms: ["logout", "sair", "desconectar"] },
      { title: "fa-solid fa-right-to-bracket", searchTerms: ["login", "entrar", "conectar"] },
      { title: "fa-solid fa-bars", searchTerms: ["menu", "hamburguer", "navegacao"] },
      { title: "fa-solid fa-ellipsis", searchTerms: ["more", "mais", "opcoes"] },
      { title: "fa-solid fa-arrow-right", searchTerms: ["arrow", "seta", "direita", "proximo"] },
      { title: "fa-solid fa-arrow-left", searchTerms: ["arrow", "seta", "esquerda", "voltar"] },
      { title: "fa-solid fa-arrow-up", searchTerms: ["arrow", "seta", "cima"] },
      { title: "fa-solid fa-arrow-down", searchTerms: ["arrow", "seta", "baixo"] },
      { title: "fa-solid fa-angles-right", searchTerms: ["forward", "avancar", "proxima"] },
      { title: "fa-solid fa-angles-left", searchTerms: ["back", "voltar", "anterior"] },
      { title: "fa-solid fa-play", searchTerms: ["play", "reproduzir", "iniciar"] },
      { title: "fa-solid fa-pause", searchTerms: ["pause", "pausar", "parar"] },
      { title: "fa-solid fa-stop", searchTerms: ["stop", "parar", "finalizar"] },
      { title: "fa-solid fa-circle-play", searchTerms: ["play", "reproduzir"] },
      { title: "fa-solid fa-circle-pause", searchTerms: ["pause", "pausar"] },
      { title: "fa-solid fa-circle-stop", searchTerms: ["stop", "parar"] },
      { title: "fa-solid fa-forward", searchTerms: ["forward", "avancar"] },
      { title: "fa-solid fa-backward", searchTerms: ["backward", "retroceder"] },
      { title: "fa-solid fa-rotate", searchTerms: ["refresh", "atualizar", "recarregar"] },
      { title: "fa-solid fa-spinner", searchTerms: ["loading", "carregando", "aguarde"] },
      { title: "fa-solid fa-circle-notch", searchTerms: ["loading", "carregando"] },
      { title: "fa-solid fa-paper-plane", searchTerms: ["send", "enviar", "mensagem"] },
      { title: "fa-solid fa-floppy-disk", searchTerms: ["save", "salvar", "disco"] },
      { title: "fa-solid fa-clipboard", searchTerms: ["clipboard", "copiar", "area de transferencia"] },
      { title: "fa-solid fa-copy", searchTerms: ["copy", "copiar", "duplicar"] },
      { title: "fa-solid fa-paste", searchTerms: ["paste", "colar"] },
      { title: "fa-solid fa-scissors", searchTerms: ["cut", "cortar", "tesoura"] },
      { title: "fa-solid fa-list", searchTerms: ["list", "lista", "itens"] },
      { title: "fa-solid fa-list-check", searchTerms: ["checklist", "lista", "tarefas"] },
      { title: "fa-solid fa-table", searchTerms: ["table", "tabela", "grid"] },
      { title: "fa-solid fa-filter", searchTerms: ["filter", "filtro", "buscar"] },
      { title: "fa-solid fa-sort", searchTerms: ["sort", "ordenar", "classificar"] },
      { title: "fa-solid fa-tag", searchTerms: ["tag", "etiqueta", "marcador"] },
      { title: "fa-solid fa-tags", searchTerms: ["tags", "etiquetas", "categorias"] },
      { title: "fa-solid fa-square", searchTerms: ["square", "quadrado"] },
      { title: "fa-solid fa-circle", searchTerms: ["circle", "circulo"] },
      { title: "fa-regular fa-square", searchTerms: ["square", "quadrado", "regular"] },
      { title: "fa-regular fa-circle", searchTerms: ["circle", "circulo", "regular"] },
      { title: "fa-regular fa-star", searchTerms: ["star", "estrela", "regular"] },
      { title: "fa-regular fa-heart", searchTerms: ["heart", "coracao", "regular"] },
    ];

    if (this.selected) {
      this.inputTarget.value = this.selected;
    }
  }

  disconnect() {
    if (this.blurTimeout) {
      clearTimeout(this.blurTimeout);
    }
  }

  focus() {
    this.focusOn = true;
    this.showPreview();
  }

  blur() {
    this.blurTimeout = setTimeout(() => {
      this.focusOn = false;
      this.hidePreview();
    }, 150);
  }

  search(event) {
    this.searchTerm = event.target.value;
    this.renderIcons();
  }

  select(event) {
    if (this.blurTimeout) {
      clearTimeout(this.blurTimeout);
    }

    const iconElement = event.target.closest(".icon-wrapper");
    if (!iconElement) return;

    const iconTitle = iconElement.dataset.iconTitle;
    
    if (this.searchTerm !== this.selected) {
      this.beforeSelect = this.searchTerm;
    }

    this.selected = iconTitle;
    this.inputTarget.value = iconTitle;
    this.searchTerm = iconTitle;
    this.inputTarget.focus();
    
    this.renderIcons();
  }

  clearSelection(event) {
    if (event.target === this.previewerTarget) {
      this.inputTarget.focus();
    }
  }

  hoverIn() {
    this.hoverPanel = true;
    this.previewerTarget.classList.add("shadow");
    this.previewerTarget.classList.remove("shadow-sm");
  }

  hoverOut() {
    this.hoverPanel = false;
    this.previewerTarget.classList.remove("shadow");
    this.previewerTarget.classList.add("shadow-sm");
  }

  showPreview() {
    this.previewContainerTarget.style.display = "block";
    this.renderIcons();
  }

  hidePreview() {
    this.previewContainerTarget.style.display = "none";
  }

  getFilteredIcons() {
    const search = (this.searchTerm === this.selected) ? this.beforeSelect : this.searchTerm;
    const searchLower = search.toLowerCase();

    if (!search) {
      return this.icons;
    }

    return this.icons.filter(icon => {
      return icon.title.toLowerCase().indexOf(searchLower) !== -1 || 
             icon.searchTerms.some(term => term.toLowerCase().indexOf(searchLower) !== -1);
    });
  }

  renderIcons() {
    const filtered = this.getFilteredIcons();
    const previewer = this.previewerTarget;
    
    previewer.innerHTML = filtered.map(icon => `
      <div class="icon-preview">
        <div 
          class="icon-wrapper rounded shadow-sm ${icon.title === this.selected ? "selected" : ""}"
          data-icon-title="${icon.title}"
          data-action="click->forms--fontawesome-picker#select"
        >
          <i class="${icon.title}"></i>
        </div>
      </div>
    `).join("");
  }
}

