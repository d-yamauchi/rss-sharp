const app = new Vue({
  el: "#main",
  data: {
    sites: [],
    errorMessage: "",
    newUrl: "",
  },
  methods: {
    async add(url) {
      if (url === "") {
        return;
      }

      this.errorMessage = "";
      const response = await fetch(`sites?url=${url}`, {method: "POST"});
      const result = await response.json();
      if (result.error === false) {
        window.location.reload();
      } else {
        this.errorMessage = "エラー";
      }
    },
  },
  created: async function () {
    const response = await fetch("sites");
    const sites = await response.json();
    this.sites.push(...sites);
  },
});
