# Home Manager 共通設定

このディレクトリは、各プロジェクトから再利用する個人向けの Home Manager
モジュールを提供する。

zsh、tmux、Neovimの設定本文は`dotfiles/`を正とする。このモジュールは
必要なパッケージを入れ、`dotfiles/`内のファイルをHome Managerで配置する。

## 管理対象

- zsh と Oh My Zsh
- tmux
- Neovim
- direnv と nix-direnv
- 日本語ロケール

AWS、Azure CLI、`xclip` は、必要なプロジェクトだけが有効化する。
これらの追加設定も`dotfiles/`内の分割ファイルを条件付きで配置する。

## 利用例

利用側の `flake.nix` でこのリポジトリを入力に追加し、Home Manager の
`modules` から共通モジュールを読み込む。

```nix
inputs.settings.url = "github:one2ndpiece/settings";

modules = [
  inputs.settings.homeManagerModules.default
  {
    one2ndpiece.enable = true;
  }
];
```

利用側の `flake.lock` が、このリポジトリのコミットを固定する。
