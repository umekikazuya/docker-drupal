# Drupalさくっと環境構築

以下実行。

```sh
git clone <リポジトリ名>
make init
```

## コマンド集

### 各コンテナへの接続

下記コマンドでログインを行う。

```sh
docker compose exec app /bin/bash
```

- アプリコンテナ接続時は www-data ユーザーを指定

```sh
docker compose exec -u www-data app bash
```

### 各コンテナの停止・起動

停止・起動は引数の最後の文字列を stop/start に変更して実行する。

```sh
docker compose start
docker compose stop
```

### ログの確認

コンテナのログを確認したい場合は以下のコマンドを使用。

```sh
docker compose logs -f
```

### 開発環境構築の削除

開発環境を削除する場合は、下記コマンドを実行。

```sh
docker compose down --rmi all
```
