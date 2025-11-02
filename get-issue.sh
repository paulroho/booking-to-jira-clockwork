# ./get-issues.sh | jq '.sections[].issues'

source ./config.sh
issue="$1"

full_url="https://$domain/rest/api/2/issue/picker?query=$issue&showSubTasks=true&currentJQL=project%20in%20projectsWhereUserHasPermission%28%22WORK%20ON%20ISSUES%22%29&_r=1761990788196"

curl -X GET $full_url \
  -H 'ap-client-key: clockwork-cloud' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -b "'$cookies'" \
  -s \
  | jq ".sections[] | select(.id == \"cs\") | .issues[] | select(.key == \"$issue\").id"
