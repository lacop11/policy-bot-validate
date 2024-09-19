#!/usr/bin/env bash
set -e

# Parse arguments. We should get two.
if [ $# -ne 2 ]; then
    echo "Usage: $0 --policy-bot-url=https://... <path to .policy.yml>"
    echo "You probably need to set \`args: ["--policy-bot-url=https://..."]\` in your"
    echo ".pre-commit-config.yaml file."
    exit 1
fi
# First argument should be the policy bot URL.
if [[ $1 != --policy-bot-url=* ]]; then
    echo "First argument should be --policy-bot-url=..."
    exit 1
fi
POLICY_BOT_URL=${1#--policy-bot-url=}
# Second argument should be the path to the .policy.yml file.
POLICY_FILE=$2

echo "URL is" $POLICY_BOT_URL
echo "File is" $POLICY_FILE

# Validate.
tmpfile=$(mktemp /tmp/policy.XXXXXX)
code=$( \
    curl "${POLICY_BOT_URL}/api/validate" \
    -XPUT \
    -T "${POLICY_FILE}" \
    -s -w "%{http_code}" \
    -o "${tmpfile}" \
)

if [[ "${rcode}" -gt 299 ]];
then
    echo "Validation failed with status code ${rcode}"
    cat /tmp/response
    exit 1
fi

echo "Validation successful"