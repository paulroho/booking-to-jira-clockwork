issue="$1"
issue_id="$2"
duration="$3"
text="$4"
start_time="$5"

full_url="https://app.clockwork.report/worklogs.json?xdm_e=https%3A%2F%2F$domain"

data_raw=$(cat <<EOF
{
    "adjust_estimate": "new",
    "new_estimate": "0m",
    "issueId": "$issue_id",
    "timeSpent": "$duration",
    "comment": "$text",
    "started": "$start_time",
    "attributes": [
        {
            "key": "m7bv8l3d",
            "value": false
        }
    ],
    "external_calendar_event_id": null
}
EOF
)

echo $issue $issue_id $duration $text $start_time

response=$(curl -s -w "%{http_code}" -X POST $full_url \
  -H 'accept: application/json, text/plain, */*' \
  -H "authorization: JWT $clockwork_jwt" \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'origin: https://app.clockwork.report' \
  -H 'pragma: no-cache' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-storage-access: active' \
  --data-raw "$data_raw")

status=${response: -3}
if [ "$status" -ne 200 ]; then
  echo "❌ Request failed (status: $status)"
  echo $data_raw | jq
else
  echo "✅ Request succeeded"
fi
