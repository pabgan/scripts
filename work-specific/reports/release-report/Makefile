.PHONY: clean copy-jira-comment copy-mail

header.md:
	@echo 'Hi all.\n\nThis is the current status of ${CUS} ${VER} release validation:' > header.md

info.md:
	@echo "## Info" > info.md
	@echo "**Started on:**  " >> info.md
	@echo "**Target date:**  " >> info.md
	@echo "**Current binary:**  " >> info.md

issues.md:
	@echo "## Issues" > issues.md
	@echo "None." >> issues.md

tickets-comments.csv:
	cut tickets.csv -d',' -f1 | tail -n+2 > tickets-comments.csv

tickets.md: tickets.csv tickets-comments.csv
	@#column -t -s',' tickets.csv > tickets.md
	@echo "## Tickets" > tickets.md
	cut -d',' -f2 --complement tickets.csv > tickets-aux.csv
	./tickets.py tickets-aux.csv tickets-comments.csv > tickets-commented.csv
	csv2md tickets-commented.csv >> tickets.md

sltp-table.md:
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
	@echo "\n\n" >> sltp.md
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
	rm -f mail.md jira-comment.md sltp.md sltp-table.md sltp-toc.txt sltp-all.txt tickets.md tickets-commented.csv

copy-html: mail.md
	pandoc -t html mail.md | xclip

jira-comment.md: mail.md
	@sed 's/-----*$$/----/' mail.md > jira-comment.md
	@sed -i 's/##### /h5. /g' jira-comment.md
	@sed -i 's/### /h3. /g' jira-comment.md
	@sed -i 's/## /h2. /g' jira-comment.md
	@sed -i 's/**/*/g' jira-comment.md
	@sed -i '/| ---/d' jira-comment.md

copy-jira: jira-comment.md
	xclip < jira-comment.md
