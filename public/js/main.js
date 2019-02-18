{
  const UPDATE_INTERVAL = 10 * 60 * 1000;

  const firstTime = new Date();
  firstTime.setDate(firstTime.getDate() - 1);
  const app = new Vue({
    el: "#application",
    data: {
      lastUpdateDate: firstTime,
      items: [],
    },
    methods: {
      async update() {
        const response = await fetch(`items?start=${this.getDateString(this.lastUpdateDate)}`);
        const json = await response.json();

        const items = json.items;
        for (const item of items) {
          const site = json.sites.find(site => site.id === item.site_id);
          item.siteName = site.name;
          item.hatenaUrl = `http://b.hatena.ne.jp/entry/${item.url}`;
        }
        this.items.push(...json.items);

        this.lastUpdateDate = new Date();

        // 最後までスクロールする。
        // すぐだとスクロールされなかったので、1秒待ってからスクロールする。
        setTimeout(() => scrollTo(0, window.document.body.offsetHeight), 1000);
      },
      getDateString(date) {
        return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
      }
    },
  });

  const loop = () => {
    app.update();
    setTimeout(loop, UPDATE_INTERVAL);
  }

  loop();
}
