# Nix 共通設定

このディレクトリは、`flake.nix`から公開するNix関連の実体を置く。

## `profile.nix`

各プロジェクトから再利用する共有ユーザープロファイルを提供する。
`flake.nix`では`homeManagerModules.profile`として公開する。

zsh、tmux、Neovim、direnvなど、dotfilesを使うための基本パッケージと
環境変数を定義する。

## `dotfiles.nix`

各プロジェクトから再利用する共有dotfiles設定を提供する。
`flake.nix`では`homeManagerModules.dotfiles`として公開する。

zsh、tmux、Neovimの設定本文は`dotfiles/`を正とする。このmoduleは
`dotfiles/`内のファイルをHome Managerで配置する。

## `aws.nix`

AWS向けの追加プロファイルを提供する。
`flake.nix`では`homeManagerModules.aws`として公開する。

`AWS_VAULT_BACKEND`などの環境変数を管理する。
Oh My ZshのAWS pluginは共通`.zshrc`で常に有効化する。

## 管理対象

- zsh と Oh My Zsh
- tmux
- Neovim
- direnv と nix-direnv
- 日本語ロケール

AWSの環境変数と`xclip`は、必要なプロジェクトだけが有効化する。
Azure CLIの補完は共通`.zshrc`で存在チェックして読み込む。

## 利用例

利用側の`flake.nix`でこのリポジトリを入力に追加し、Home Managerの
`modules`から共通moduleを読み込む。

```nix
inputs.settings.url = "github:one2ndpiece/settings";

modules = [
  inputs.settings.homeManagerModules.profile
  inputs.settings.homeManagerModules.dotfiles
  inputs.settings.homeManagerModules.aws
  {
    aws.enable = false;
    dotfiles.clipboard.enable = false;
  }
];
```

利用側の`flake.lock`が、このリポジトリのコミットを固定する。
