# Booking To Jira Clockwork

This repo has a handful scripts that help creating time bookings in the Clockwork app on Jira.

## Disclaimer
These scripts work fine for me, but might miss things important for you environment (configure for your environment in [config.sh](./config.sh)).

Please send a PR if you improved or fixed the scripts.

> * This code is provided as is. No warranty given.
> * Carefully configure the system.
> * Watch the log outputs.
> * Check the created time bookings.
> * You use the code in this repo at **your own risk**.

## Getting Started

### 0. Configure
* Log in to Jira
* Go to Clockwork app
* Extract cookies
* Provide configuration for your environment in `config.sh`. Refer to [config.tempalte.sh](./config.template.sh).

### 1. Provide Bookings
* Provide your bookings in `bookings.json`:
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
Refer to [bookings.template.json](./bookings.template.json).

### 2. Get JWT For Clockwork
* Run `export clockwork_jwt=$("./get-clockwork-jwt.sh")`
  * Expires 15 minutes after retrieval
  * Consider using `./clockwork-jwt-expiry.sh` to inspect see if it is already expired

### 3. Write The Bookings To Clockwork
* Run `./write-bookings.sh`
  * Lookout for failures!


## How It Works
### No Begin Time For Bookings
There is no begin time for the bookings - it's all about the duration. **All bookings for a day are stacked** starting at a [configurable](./config.sh) time of day.

If you need the exact time of day for each booking, feel free to provide a PR for that alternative.


## How It Was Done
These scripts are a wild mixture of reverse engineering of what the browser does when booking to Clockwork and some vibe coded scripts to make it generally usable.
