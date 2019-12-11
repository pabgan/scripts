backupator.sql and rollbackator.sql are two scripts designed to help backing
up tables and rolling back changes on them.

To use backupator.sql and rollbackator.sql scripts do:
	1. Copy them to your directory.
	2. Edit them to set variables to match the tables you needed. Edit
	   one and copy changes to the other to avoid mistakes.
	3. Execute it like:
		$ sqlplus demo_b/assia @pathtoyourfolder/rollbackator.sql

