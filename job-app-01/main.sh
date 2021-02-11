#!/bin/sh -e

################################################################################
# $ sh main.sh $(date -d '1 month ago' +'%Y-%m'-01) $(date '+%Y-%m'-01)
################################################################################

aws configure list

readonly LAST_MONTH_DAY_1=$1 #`date -d '1 month ago' +'%Y-%m'`-01
readonly CURRENT_MONTH_DAY_1=$2 #`date '+%Y-%m'`-01

echo 開始：${LAST_MONTH_DAY_1}
echo 終了：${CURRENT_MONTH_DAY_1}

#aws ce get-dimension-values --time-period Start=${LAST_MONTH_DAY_1},End=${CURRENT_MONTH_DAY_1} --dimension SERVICE --context COST_AND_USAGE \

echo 'サービス,使用量(単位:不明),割引前料金,割引後料金'
aws ce get-cost-and-usage \
  --region ap-northeast-1 \
  --time-period Start=${LAST_MONTH_DAY_1},End=${CURRENT_MONTH_DAY_1} \
  --granularity MONTHLY \
  --metrics "UnblendedCost" "BlendedCost" "UsageQuantity" \
  --group-by Type=DIMENSION,Key=SERVICE \
| jq -rc '.ResultsByTime[].Groups[] | [.Keys[], .Metrics.UsageQuantity.Amount, .Metrics.UnblendedCost.Amount, .Metrics.BlendedCost.Amount ] | @csv' \
| sed -e 's/"//g'
