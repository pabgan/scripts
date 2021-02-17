.PHONY: clean

header.md:
	@echo 'Hi all.\n\nThis is the current status of ${CUSTOMER_NAME} ${CUSTOMER_VER} release validation:' > header.md

info.md:
	@echo "## Info" > info.md
	@echo "**Start date:**  \\" >> info.md
	@echo "**Target date:**  \\" >> info.md
	@echo "**Tested binary:**  \\" >> info.md
	@echo "**Tested DB script:** \\" >> info.md


issues.md:
	@echo "## Issues" > issues.md
	@echo "None." >> issues.md

tickets-comments.csv:
	cut tickets.csv -d';' -f1 > tickets-comments.csv
	sed -i '/KEY/d' tickets-comments.csv
	sed -i 's/$$/;/' tickets-comments.csv

tickets.csv: fix-versions.txt
	jira_turbo.py query --issues 'project = DSLE AND fixVersion in ( $(shell cat fix-versions.txt) ) and status!=CLOSED' > tickets.csv

tickets.md: tickets.csv tickets-comments.csv
	@echo "## Tickets" > tickets.md
	./tickets.py tickets.csv tickets-comments.csv > tickets-commented.csv
	csv2md -d';' tickets-commented.csv >> tickets.md


sltp.docm:
	if [ ! -e '../sltp/System Test Plan.docm' ]; then \
		mkdir -p ../sltp/ ; \
		echo 'Not started.' > '../sltp/System Test Plan.docm' ; \
	fi
	ln -s '../sltp/System Test Plan.docm' sltp.docm

sltp-table.md: sltp.docm
	docx2txt < sltp.docm > sltp-all.txt
	grep -A117 -E 'Table of Contents\s*[0-9]*' sltp-all.txt | grep -A1 -E '^[3-5]' > sltp-toc.txt
	sed -i 's/\s\+[0-9]\+$$//' sltp-toc.txt
	./sltp.py sltp-toc.txt > sltp-table.md

sltp-comments.md:
	@echo "##### Comments" > sltp-comments.md
	@echo "None" >> sltp-comments.md

sltp.md: sltp-table.md sltp-comments.md
	@echo "## System Level Test Plan" > sltp.md
	@cat sltp-comments.md >> sltp.md
	@echo "\n" >> sltp.md
	@cat sltp-table.md >> sltp.md

goodbye.md:
	@echo 'Best regards.' > goodbye.md

mail.md: clean header.md info.md issues.md tickets.md sltp.md goodbye.md
	@cat header.md >> mail.md
	@echo "\n" >> mail.md
	@cat info.md >> mail.md
	@echo "\n" >> mail.md
	@cat issues.md >> mail.md
	@echo "\n" >> mail.md
	@cat tickets.md >> mail.md
	@echo "\n" >> mail.md
	@cat sltp.md >> mail.md
	@echo "\n" >> mail.md
	@cat goodbye.md >> mail.md

clean:
	rm -f mail.md jira-comment.md sltp.md sltp-table.md sltp-toc.txt sltp-all.txt tickets.md tickets.csv tickets-commented.csv
