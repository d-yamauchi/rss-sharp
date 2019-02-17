const app = new Vue({
  el: "#main",
  data: {
    sites: []
  },
  methods: {

  },
  created: async function () {
    const response = await fetch("sites");
    const sites = await response.json();
    this.sites.push(...sites);
  },
});
