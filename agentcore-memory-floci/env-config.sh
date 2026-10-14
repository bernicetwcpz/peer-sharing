# Usage: source env-config.sh [--cleanup]

if [ "$1" = "--cleanup" ]; then
  echo "Cleanup AWS environment variables for floci environment"
  unset AWS_ENDPOINT_URL AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION \
    FLOCI_SERVICES_BEDROCK_AGENT_CORE_CONTROL_ENABLED FLOCI_SERVICES_BEDROCK_AGENT_CORE_ENABLED
else
  echo "Configure AWS environment variables for floci environment"
  export AWS_ENDPOINT_URL="http://localhost:4566"
  export AWS_ACCESS_KEY_ID="test"
  export AWS_SECRET_ACCESS_KEY="test"
  export AWS_DEFAULT_REGION="ap-southeast-1"

  export FLOCI_SERVICES_BEDROCK_AGENT_CORE_CONTROL_ENABLED=true
  export FLOCI_SERVICES_BEDROCK_AGENT_CORE_ENABLED=true
fi
