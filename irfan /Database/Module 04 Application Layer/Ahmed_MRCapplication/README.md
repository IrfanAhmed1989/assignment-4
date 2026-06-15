\# Ahmed\_MRCapplication



Command-line application for the MRC database assignment (Week 4).  

Runs on Windows 11 with no manual package installs. A GUI will be added in Week 5.



---



\## 1) Prerequisites



\- \*\*MySQL Server\*\* running locally (default port \*\*3306\*\*).

\- \*\*MySQL Workbench\*\* to run the starter SQL.

\- The Week 4 starter script: `Starter\_Code\_Week\_4+5.sql`.



> \*\*Important:\*\* Per assignment, run the starter script in MySQL Workbench \*\*each time\*\* you restart your code to ensure a clean `mrc` database.



\### Load the starter database



1\. Open \*\*MySQL Workbench\*\* and connect to your server.

2\. `File → Open SQL Script…` → select `Starter\_Code\_Week\_4+5.sql`.

3\. Click \*\*Execute\*\* (lightning bolt).

4\. Quick check (optional):

&nbsp;  ```sql

&nbsp;  SELECT \* FROM mrc.vessels;

