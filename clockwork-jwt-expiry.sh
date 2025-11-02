expires=$(echo $clockwork_jwt | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq '.exp')

now=$(date +%s)

if [ "$expires" -le "$now" ]; then
  echo "❌ The Clockwork JWT has already expired"
  echo "Get a new token:"
  echo 'export clockwork_jwt=$("./get-clockwork-jwt.sh")'
else
  expiry_date=$(date -r $expires)
  echo "✅ Clockwork JWT is valid - expires $expiry_date"
fi

