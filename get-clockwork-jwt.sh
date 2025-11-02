# ./get-clockwork-jwt.sh

source ./config.sh

full_url="https://$domain/plugins/servlet/ac/clockwork-cloud/clockwork-mywork"
data_raw="plugin-key=clockwork-cloud&product-context=%7B%22project.id%22%3A%2210203%22%2C%22project.key%22%3A%22$proj_key%22%7D&key=clockwork-mywork&width=100%25&height=100%25&classifier=json"

curl -X POST $full_url \
  -H 'accept: */*' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -b "'$cookies'" \
  -H "origin: https://$domain" \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  --data-raw $data_raw \
  -s \
  | jq -r '.contextJwt'
  