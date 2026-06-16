# Dev Containerテンプレート

## `nix/`

新規プロジェクト向けの現行テンプレート。

- `image/`: GHCRへ公開するUbuntu + Nix共通ベースイメージ
- `template/`: 共通ベースイメージを利用するプロジェクト側のひな形

共通ベースイメージ:

```text
ghcr.io/one2ndpiece/nix-devcontainer:ubuntu-24.04
```

このイメージはUbuntu 24.04、Nix、`ja_JP.UTF-8` localeを含む。

このタグは週次で再ビルドし、最新の`ubuntu:24.04`とNixを取り込む。
各プロジェクトへの反映は、Dev ContainerのRebuildを手動で実行する。

イメージはGitHub Container Registryに保存され、次のページで確認できる。

```text
https://github.com/one2ndpiece/settings/pkgs/container/nix-devcontainer
```

`.github/workflows/nix-devcontainer.yaml`は次の場合にamd64とArm64を検証し、
成功した場合だけイメージを公開する。

- 共通イメージまたはworkflowを`main`へpushしたとき
- 毎週月曜日3時（日本時間）
- GitHub Actionsから手動実行したとき

初回公開後はGitHubのパッケージ設定で
`nix-devcontainer`のvisibilityを`Public`へ変更する。初回workflowが完了するまで
パッケージページと公開イメージは存在しない。

プロジェクト固有のCLIや設定は、各プロジェクトの
`home-manager/root-devcontainer.nix`へ追加する。

新規プロジェクトでは`template/`の内容を配置する。`Dockerfile`、
`devcontainer.json`、`devcontainer-lock.json`、`copy-ssh.sh`はプロジェクトの
`.devcontainer/`へ置き、残りはリポジトリルートへ置く。最初のRebuild前に
`nix flake lock`を実行して`flake.lock`を作成する。

SSH鍵をコピーする場合は、ホスト側のSSHディレクトリを読み取り専用で
`/opt/.ssh`へマウントする。マウントしない場合、`copy-ssh.sh`は何もせず終了する。

## `legacy-mise/`

旧miseベースの凍結済みテンプレート。既存プロジェクトの参照用に残す。

- 新規プロジェクトでは使用しない
- 機能追加や通常の不具合修正は行わない
- 既存プロジェクトは必要になった時点で個別にNix方式へ移行する
