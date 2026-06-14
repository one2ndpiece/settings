# Home Manager 共通設定

このディレクトリは、各プロジェクトから再利用する個人向けの Home Manager
モジュールを提供する。

## 管理対象

- zsh と Oh My Zsh
- tmux
- Neovim
- direnv と nix-direnv
- 日本語ロケール

AWS、Azure CLI、`aicommit2`、`xclip` は、必要なプロジェクトだけが有効化する。

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
