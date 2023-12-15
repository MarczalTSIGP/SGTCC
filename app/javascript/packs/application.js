import $ from "jquery";
import "bootstrap";
import "@hotwired/turbo-rails";
import Vue from "vue";
import VueI18n from "vue-i18n";

console.log("packs");

// import TurbolinksAdapter from "vue-turbolinks";
// import VueSwal from "vue-swal";
// import VueHtmlToPaper from "vue-html-to-paper";
// import VueClipboard from "vue-clipboard2";
// import "babel-polyfill";

// import { axios } from "../utils/axios/axios-config";
// import { messages } from "../utils/i18n/messages";
// import { components } from "./components";

// import menu from "../initializers/menu";
// import markdown from "../initializers/markdown-editor";
// import selectize from "../initializers/selectize";
// import datetimepicker from "../initializers/datetimepicker";
// import tooltip from "../initializers/tooltip";
// import sidebarScroll from "../initializers/sidebar-scroll";
// import fileInput from "../initializers/file-input";
// import rangeInput from "../initializers/range-input";
// import examinationBoards from "../initializers/examination-boards";
// import hideShowActivityFields from "../initializers/hide-show-activity-fields";

// Vue.prototype.$axios = axios;
// Vue.use(TurbolinksAdapter);
// Vue.use(VueI18n);
// Vue.use(VueSwal);
// Vue.use(VueClipboard);

// const styles = [
//   "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
// ];

// const link = document.querySelectorAll('link[media="print"]')[0];
// if (link != undefined) {
//   styles.push(link.href);
// }

// const options = {
//   name: "_blank",
//   specs: ["fullscreen=yes", "titlebar=no", "scrollbars=yes"],
//   styles: styles
// };

// Vue.use(VueHtmlToPaper, options);

// const i18n = new VueI18n({
//   locale: "pt-BR",
//   messages
// });

// console.log("Application.js");

// document.addEventListener("turbo:load", () => {
//   new Vue({
//     i18n,
//     el: "#app",
//     components,
//     mixins: [
//       datetimepicker,
//       fileInput,
//       markdown,
//       menu,
//       selectize,
//       sidebarScroll,
//       tooltip,
//       rangeInput,
//       examinationBoards,
//       hideShowActivityFields
//     ]
//   });
// });
