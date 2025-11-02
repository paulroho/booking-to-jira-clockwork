# Booking to Jira Clockwork

This repo has a handful scripts that help creating time bookings in the Clockwork app on Jira.

It works fine for me on one installation. Please send a PR if you find any issues.

> * This code is provided as is. No warranty given.
> * Carefully configure the system.
> * Watch the log outputs.
> * Check the created time bookings.
> * You use the code in this repo at your own risk.

## 0. Configure
* Log in to Jira
* Go to Clockwork app
* Extract cookies
* Update values in [config.sh](./config.sh)

## 1. Prepare Bookings
* Write your bookings into [bookings.json](./bookings.json)
* Format:
```json
[
  {
    "date": "2025-10-03",
    "issue": "MYPROJ-123",
    "duration": "0h 15m",
    "text": "That's what I did"
  },
  ...
]
```

## 2. Get JWT for Clockwork
* Run `export clockwork_jwt=$("./get-clockwork-jwt.sh")`
  * Expires 15 minutes after retrieval
  * Consider using `./clockwork-jwt-expiry.sh` to inspect see if it is already expired

## 3. Write the the Bookings to the Worklog
* Run `./write-bookings.sh`
  * Lookout for failures!