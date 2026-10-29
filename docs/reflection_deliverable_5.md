# 📝 Reflection - Deliverable 5: Data Checks

## 🎯 What I Did
For this deliverable, I turned the checks I had been doing by hand into one script, `sql/08_data_checks.sql`. Each check counts the **bad rows**, the rows that break a rule. If there are 0 bad rows the check says PASS, and the script shows all the checks in one table, so anyone can run it after the pipeline and see every stamp at once.

I wrote the script one check at a time, ran it after each new check, and ended with 7 checks:

- **🔁 No duplicate orders:** each `order_id` appears once in `staging.orders`.
- **🔁 No duplicate items:** each (`order_id`, `order_item_id`) pair appears once in the fact table. The primary key already makes this impossible, but the check still works if someone removes the key later.
- **🔗 No orphan fact rows:** every row in `fact_order_items` finds its customer, product, seller and day.
- **💰 Money matches staging:** the price total and the freight total in the fact table equal the totals in staging.
- **➖ No negative money:** no price or freight value is below 0. A freight of 0.00 passes, because it probably means free shipping.
- **⭐ Review scores 1 to 5:** every score is between 1 and 5, and none is empty.
- **📦 Delivered orders have a delivery date:** this check finds the 8 `delivered` orders with no delivery date that I kept in Deliverable 3.

All of the first six checks gave PASS. The seventh gave 8 bad rows, so I had to decide what to do with a check that fails on data I chose to keep.

## 💡 What I Learned
- ✅ A check counts the bad rows, because 0 is the number that means "everything is fine", and a count also shows how big a problem is.
- ✅ `UNION ALL` puts all the checks in one table, and only the last line of the file ends with `;`, because the whole file is one instruction.
- ✅ A check that always says PASS is useless, so I made the 8 known orders fail first, to see that my checks can find a problem.
- ✅ If a check always says FAIL for a problem I already know about, people stop trusting the stamps. I used three stamps: PASS for 0 bad rows, WARN for up to the 8 known ones, and FAIL for anything more, so the old problem stays visible and a new problem still raises an alarm.
- ✅ In a `CASE`, the database uses the first line that is true, so `= 0` has to come before `<= 8`.
- ✅ `NOT BETWEEN 1 AND 5` does not see an empty score, because the answer for an empty value is "unknown", so I added `OR review_score IS NULL`. `IS DISTINCT FROM` also works with empty values, which is why I used it to compare the money totals.
- ✅ Six PASS stamps do not prove the data is perfect. A check only tests the rule I wrote, so there can still be problems I did not think of.

## 🧗 Challenges I Faced
- Deciding what to do with the check for delivered orders. If I left it out, I would hide a known problem. If I kept it as a normal check, it would fail every time. I chose the WARN stamp, which has one weakness: the number 8 is written into the check by hand, so I must update it if the data is reloaded.
- Understanding why an empty score slips past `NOT BETWEEN 1 AND 5`, which I only understood after I thought about what the database answers when a value is empty.

## 🛠️ Tools Used
`PostgreSQL 16` · `SQL` (`UNION ALL`, `CASE`, `NOT EXISTS`, `IS DISTINCT FROM`, `HAVING`) · `Docker Compose` · `PowerShell` · `Git` · `GitHub` · `VS Code`

---
*Deliverable 5 of the Olist Data Pipeline project*