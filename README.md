# RSS#

RSSリーダーです。
Ruby on Railsの勉強のために作りました。

## 使い方
```
docker-compose run web rails new . --force --database=mysql
docker-compose build

# サーバー起動
docker-compose up

# データベースの用意（初回のみ）
docker-compose run web rake db:create

# 画面を開く
http://localhost:3000/ にアクセス

# サーバー停止
docker-compose down
```
