# Usage (from the repo root): source env-config.sh [--cleanup]
# Points AWS CLI / SDK / agentcore-cli at floci instead of real AWS

if [ "$1" = "--cleanup" ]; then
  echo "Cleanup AWS environment variables for floci environment"
  unset AWS_ENDPOINT_URL AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION
else
  echo "Configure AWS environment variables for floci environment"
  export AWS_ENDPOINT_URL="http://localhost:${FLOCI_PORT:-4566}"
  export AWS_ACCESS_KEY_ID="test"
  export AWS_SECRET_ACCESS_KEY="test"
  export AWS_DEFAULT_REGION="ap-southeast-1"
fi
