export default {
  name: 'Sidebar',

  methods: {
    aClass(url) {
      return `list-group-item list-group-item-action ${this.isActiveLink(url)}`;
    },

    isActiveLink(url) {
      return window.location.pathname === `/${url}` ? 'active' : '';
    },
  },
};
