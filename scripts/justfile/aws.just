# list
default:
  just --list aws
# windowsインスタンスのキーを取得
[arg("instance-id",long="instance-id",short="i")]
[arg("key",long="key",short="k",help='/root/.ssh/logi-test-key-2.pemみたいなpemファイルのパス')]
ec2-windows-instance-key instance-id key:
  aws ec2 get-password-data --instance-id {{instance-id}} --priv-launch-key {{key}}
# devcontainer内からsam local invokeを実行するためのコマンド
sam-local-invoke:
  sam build --use-container
  sam local invoke --event payload.json --container-host host.docker.internal  --container-host-interface 0.0.0.0
# devcontainer内からsam local start-apiを実行するためのコマンド
sam-local-start-api:
  sam build --use-container
  sam local start-api --container-host host.docker.internal  --container-host-interface 0.0.0.0
# Quicksightダッシュボードのリストを取得
[group("quicksight")]
qs-dashboard-list account-id:
  aws quicksight list-dashboards --aws-account-id {{account-id}} | jq '.DashboardSummaryList[] | {DashboardId, Name}'
# Quicksightダッシュボードの詳細を取得
[group("quicksight")]
qs-dasboard-list-detail account-id:
  aws quicksight list-dashboards --aws-account-id {{account-id}}
# データセットを取得。jqでデータセットIDと名前を取得。OR条件
[group("quicksight")]
qs-dataset-list-or account-id word1 word2:
  aws quicksight list-data-sets --aws-account-id {{account-id}} | jq '.DataSetSummaries[] | select(.Name | contains("{{word1}}") or contains("{{word2}}")) | {DataSetId, Name}'
# AND条件
[group("quicksight")]
qs-dataset-list-and account-id word1 word2:
  aws quicksight list-data-sets --aws-account-id {{account-id}} | jq '.DataSetSummaries[] | select(.Name | contains("{{word1}}") and (contains("{{word2}}") | not)) | {DataSetId, Name}'
# データセットを更新
[group("quicksight")]
qs-dataset-update account-id dataset-id:
  aws quicksight create-ingestion --aws-account-id {{account-id}} --data-set-id {{dataset-id}} --ingestion-id "ingestion-$(date +%Y%m%d%H%M%S)"
