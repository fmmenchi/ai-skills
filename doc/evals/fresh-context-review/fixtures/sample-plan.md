# Sample plan — a nightly report job

- **Status:** revision 1
- **Owner:** the eval

## Goal

Every night at 02:00 a job reads the day's orders, computes the totals per region, and mails a
PDF to the operations list. If the job fails, nobody should have to notice by hand.

## Steps

| # | Step | Produces |
| --- | --- | --- |
| 1 | Fetch orders for the previous day from the orders API | `orders.json` |
| 2 | Compute totals per region | `totals.json` |
| 3 | Render the PDF | `report.pdf` |
| 4 | Verify the report | `verified` flag |
| 5 | Mail the PDF to the operations list | a sent message |
| 6 | Post the mail's delivery status to the status page | a status entry |

Step 4 verifies the report by comparing its totals with the finance system's figures for the
same day, which the finance system publishes at 06:00.

## Failure handling

The job retries any failed step up to five times. After the fifth failure it stops and the
status page shows red, so the operations team notices in the morning.

## Exit criterion

The job is considered working when the operations team is satisfied with the reports.

## Assumptions

The orders API is fast enough to fetch a day in one call.
