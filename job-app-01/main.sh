#!/bin/bash
set -euo pipefail

################################################################################
# $ sh main.sh $(date -d '1 month ago' +'%Y-%m'-01) $(date '+%Y-%m'-01)
################################################################################

readonly LAST_MONTH_DAY_1=$1 #`date -d '1 month ago' +'%Y-%m'`-01
readonly CURRENT_MONTH_DAY_1=$2 #`date '+%Y-%m'`-01

echo 開始：${LAST_MONTH_DAY_1}
echo 終了：${CURRENT_MONTH_DAY_1}

echo ===========================================================================
env
echo ===========================================================================

echo 'サービス,使用量(単位:不明),割引前料金,割引後料金'
aws ce get-cost-and-usage \
  --region ap-northeast-1 \
  --time-period Start=${LAST_MONTH_DAY_1},End=${CURRENT_MONTH_DAY_1} \
  --granularity MONTHLY \
  --metrics "UnblendedCost" "BlendedCost" "UsageQuantity" \
  --group-by Type=DIMENSION,Key=SERVICE \
| jq -rc '.ResultsByTime[].Groups[] | [.Keys[], .Metrics.UsageQuantity.Amount, .Metrics.UnblendedCost.Amount, .Metrics.BlendedCost.Amount ] | @csv' \
| sed -e 's/"//g' \
| sed -e 's/AWS //g' \
| sed -e 's/Amazon //g' \
| sed -e 's/Key Management Service/KMS/g' \
| sed -e 's/EC2 Container Registry (ECR)/ECR/g' \
| sed -e 's/EC2 Container Service/ECS(EC2)/g' \
| sed -e 's/EC2 - Other/EC2-Other/g' \
| sed -e 's/Elastic Compute Cloud - Compute/EC2/g' \
| sed -e 's/Elastic Container Service for Kubernetes/EKS/g' \
| sed -e 's/Elastic Load Balancing/ELB/g' \
| sed -e 's/Route 53/Route53/g' \
| sed -e 's/Simple Notification Service/SNS/g' \
| sed -e 's/Simple Queue Service/SQS/g' \
| sed -e 's/Simple Storage Service/S3/g' \
| sed -e 's/AmazonCloudWatch/CloudWatch/g' \
