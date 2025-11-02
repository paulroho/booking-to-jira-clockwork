#!/bin/bash
set -euo pipefail

source ./config.sh

json_file="bookings.json"

# Function to convert a duration like "1h 30m" or "45m" to minutes
to_minutes() {
    local duration="$1"
    local hours=$(echo "$duration" | grep -oE '[0-9]+h' | tr -d 'h' || echo 0)
    local mins=$(echo "$duration" | grep -oE '[0-9]+m' | tr -d 'm' || echo 0)
    echo $((hours * 60 + mins))
}

add_minutes() {
    local time="$1"
    local minutes="$2"
    date -v +"${minutes}"M -jf "%H:%M" "$time" +%H:%M
}

# Use jq to group by date and process one day at a time
for date in $(jq -r '.[].date' "$json_file" | sort -u); do
    echo "=== Processing date: $date ==="

    current_time="$start_bookings_at"

    # filter bookings for this date, maintain order
    jq -c --arg d "$date" '[.[] | select(.date == $d)] | .[]' "$json_file" | while read -r entry; do
        issue=$(echo "$entry" | jq -r '.issue')
        duration=$(echo "$entry" | jq -r '.duration')
        text=$(echo "$entry" | jq -r '.text')

        # Step (i): get the issue ID
        issue_id=$(./get-issue.sh "$issue")

        full_time="$date"T$current_time:00.000+01""
        # echo $issue $issue_id $duration $text $full_time
        # Step (ii): write the worklog entry
        ./write-worklog-entry.sh "$issue" "$issue_id" "$duration" "$text" "$full_time"

        # Update current_time = current_time + duration
        minutes=$(to_minutes "$duration")
        current_time=$(add_minutes "$current_time" "$minutes")
    done
done
