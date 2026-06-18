# Nix 共通設定

このディレクトリは、`flake.nix`から公開するNix関連の実体を置く。

## `dotfiles.nix`

各プロジェクトから再利用する共有dotfilesプロファイルを提供する。
`flake.nix`では`homeManagerModules.default`として公開する。

zsh、tmux、Neovimの設定本文は`dotfiles/`を正とする。このmoduleは
必要なパッケージを入れ、`dotfiles/`内のファイルをHome Managerで配置する。

## 管理対象

- zsh と Oh My Zsh
- tmux
- Neovim
- direnv と nix-direnv
- 日本語ロケール

AWS、Azure CLI、`xclip`は、必要なプロジェクトだけが有効化する。
これらの追加設定も`dotfiles/`内の分割ファイルを条件付きで配置する。

## 利用例

利用側の`flake.nix`でこのリポジトリを入力に追加し、Home Managerの
`modules`から共通moduleを読み込む。

```nix
inputs.settings.url = "github:one2ndpiece/settings";

modules = [
  inputs.settings.homeManagerModules.default
  {
    userProfile.enable = true;
  }
];
```

利用側の`flake.lock`が、このリポジトリのコミットを固定する。
