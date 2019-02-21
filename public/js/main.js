{
  const UPDATE_INTERVAL = 10 * 60 * 1000;
  const MAX_ITEM_COUNT = 200;
  const SEND_UNREAD_INTERBAL = 5000;

  const sleep = async ms => new Promise(r => setTimeout(r, ms));

  const firstTime = new Date();
  firstTime.setDate(firstTime.getDate() - 1);
  const app = new Vue({
    el: "#application",
    data: {
      lastUpdateDate: firstTime,
      items: [],
      unreadItems: [],
      isPendingUnreadSend: false,
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

        if (this.items.length > MAX_ITEM_COUNT) {
          const overCount = this.items.length - MAX_ITEM_COUNT;
          this.items.splice(0, overCount);
        }

        // 最後までスクロールする。
        // すぐだとスクロールされなかったので、1秒待ってからスクロールする。
        setTimeout(() => scrollTo(0, window.document.body.offsetHeight), 1000);
      },
      getDateString(date) {
        return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
      },
      setAsRead(item) {
        if (!item.unread) {
          return;
        }

        item.unread = false;
        this.unreadItems.push(item);
        this.sendUnread();
      },
      async sendUnread() {
        if (this.isPendingUnreadSend) {
          return;
        }

        if (this.unreadItems.length === 0) {
          return;
        }

        await sleep(SEND_UNREAD_INTERBAL);

        this.isPendingUnreadSend = true;
        const targetUnreadItems = this.unreadItems.splice(0);

        await fetch(`items/?items=${targetUnreadItems.map(item => item.id).join(",")}`, {method: "PATCH"});

        this.isPendingUnreadSend = false;
        this.sendUnread();
      }
    },
  });

  const loop = () => {
    app.update();
    setTimeout(loop, UPDATE_INTERVAL);
  }

  loop();
}
