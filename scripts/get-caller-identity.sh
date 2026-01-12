#!/usr/bin/env bash

# 現在の認証情報を取得（エラー出力を抑制、1回のAPI呼び出しで両方取得）
IDENTITY=$(aws sts get-caller-identity --output json 2>/dev/null)

# 認証に失敗した場合
if [ $? -ne 0 ] || [ -z "$IDENTITY" ]; then
  echo ""
  echo "Profile: ${AWS_PROFILE:-default} (not authenticated or invalid)"
  echo "Role: N/A"
  exit 0
fi

# JSONから値を抽出
ARN=$(echo "$IDENTITY" | grep -o '"Arn"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
ACCOUNT=$(echo "$IDENTITY" | grep -o '"Account"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

# ARNからロール名を抽出
if [[ $ARN == *":assumed-role/"* ]]; then
  ROLE=$(echo $ARN | sed 's/.*:assumed-role\/\([^\/]*\).*/\1/' | sed 's/^[^_]*_\(.*\)_[^_]*$/\1/')
elif [[ $ARN == *":role/"* ]]; then
  ROLE=$(echo $ARN | sed 's/.*:role\/\(.*\)/\1/' | sed 's/^[^_]*_\(.*\)_[^_]*$/\1/')
else
  ROLE="N/A"
fi

# プロファイル名を設定ファイルから検索（API呼び出しを最小化）
for profile in $(aws configure list-profiles); do
  # defaultセクションと通常のprofileセクションを区別して検索
  if [ "$profile" = "default" ]; then
    PROFILE_ACCOUNT=$(grep -A5 "^\[default\]" ~/.aws/config 2>/dev/null | grep "sso_account_id" | awk '{print $3}')
  else
    PROFILE_ACCOUNT=$(grep -A5 "^\[profile $profile\]" ~/.aws/config 2>/dev/null | grep "sso_account_id" | awk '{print $3}')
  fi
  
  if [ "$PROFILE_ACCOUNT" = "$ACCOUNT" ]; then
    # アカウント名を取得
    if [ "$profile" = "default" ]; then
      ACCOUNT_NAME=$(grep -A10 "^\[default\]" ~/.aws/config 2>/dev/null | grep "account_name" | head -1 | awk '{print $3}')
    else
      ACCOUNT_NAME=$(grep -A10 "^\[profile $profile\]" ~/.aws/config 2>/dev/null | grep "account_name" | head -1 | awk '{print $3}')
    fi
    
    echo ""
    echo "Profile: $profile"
    echo "Role: $ROLE"
    if [ -n "$ACCOUNT_NAME" ]; then
      echo "Account Name: $ACCOUNT_NAME"
    fi
    echo ""
    echo "aws sts get-caller-identity:"
    echo "$IDENTITY"
    exit 0
  fi
done

# 見つからなかった場合は環境変数を表示
echo ""
echo "Profile: ${AWS_PROFILE:-unknown}"
echo "Role: $ROLE"
echo ""
echo "aws sts get-caller-identity:"
echo "$IDENTITY"

# ワンライナー版:
# IDENTITY=$(aws sts get-caller-identity --output json 2>/dev/null); if [ $? -ne 0 ] || [ -z "$IDENTITY" ]; then echo ""; echo "Profile: ${AWS_PROFILE:-default} (not authenticated or invalid)"; echo "Role: N/A"; else ARN=$(echo "$IDENTITY" | grep -o '"Arn"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4); ACCOUNT=$(echo "$IDENTITY" | grep -o '"Account"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4); ROLE=$(echo $ARN | sed 's/.*:assumed-role\/\([^\/]*\).*/\1/' | sed 's/^[^_]*_\(.*\)_[^_]*$/\1/'); for profile in $(aws configure list-profiles); do if [ "$profile" = "default" ]; then PROFILE_ACCOUNT=$(grep -A5 "^\[default\]" ~/.aws/config 2>/dev/null | grep "sso_account_id" | awk '{print $3}'); else PROFILE_ACCOUNT=$(grep -A5 "^\[profile $profile\]" ~/.aws/config 2>/dev/null | grep "sso_account_id" | awk '{print $3}'); fi; if [ "$PROFILE_ACCOUNT" = "$ACCOUNT" ]; then if [ "$profile" = "default" ]; then ACCOUNT_NAME=$(grep -A10 "^\[default\]" ~/.aws/config 2>/dev/null | grep "account_name" | head -1 | awk '{print $3}'); else ACCOUNT_NAME=$(grep -A10 "^\[profile $profile\]" ~/.aws/config 2>/dev/null | grep "account_name" | head -1 | awk '{print $3}'); fi; echo ""; echo "Profile: $profile"; echo "Role: $ROLE"; [ -n "$ACCOUNT_NAME" ] && echo "Account Name: $ACCOUNT_NAME"; echo ""; echo "aws sts get-caller-identity:"; echo "$IDENTITY"; break; fi; done; fi
