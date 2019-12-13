header.md:
	@echo 'Hi all.\n\nThis is the current status of ${CUS} ${VER} release validation:' > header.md

info.md:
	@echo "Info" > info.md
	@echo "----" >> info.md
	@echo "**Started on:** " >> info.md
	@echo "**Target date:** " >> info.md
	@echo "**Current binary:** " >> info.md

issues.md:
	@echo "Issues" > issues.md
	@echo "------" >> issues.md
	@echo "None." >> issues.md

tickets.md: tickets.csv
	@#column -t -s',' tickets.csv > tickets.md
	@echo "Tickets" > tickets.md
	@echo "-------" >> tickets.md
	./tickets.py tickets.csv tickets-comments.csv > tickets-aux.csv
	cut -d',' -f2 --complement tickets-aux.csv > tickets-commented.csv
	csv2md tickets-commented.csv >> tickets.md

sltp.txt:
	docx2txt < ../sltp/System\ Test\ Plan.docm > sltp.txt

sltp.md: sltp.txt
	@echo "System Level Test Plan" > sltp.md
	@echo "----------------------" >> sltp.md
	grep -A117 -E 'Table of Contents\s+[0-9]' sltp.txt | grep -A1 -E '^[3-5]' >> sltp.md
	sed -i 's/\s\+[0-9]\+$$//' sltp.md

goodbye.md:
	@echo 'Best regards.' > goodbye.md

mail.mkd: header.md info.md issues.md tickets.md sltp.md goodbye.md
	@cat header.md >> mail.mkd
	@echo "\n" >> mail.mkd
	@cat info.md >> mail.mkd
	@echo "\n" >> mail.mkd
	@cat issues.md >> mail.mkd
	@echo "\n" >> mail.mkd
	@cat tickets.md >> mail.mkd
	@echo "\n" >> mail.mkd
	@cat sltp.md >> mail.mkd
	@echo "\n" >> mail.mkd
	@cat goodbye.md >> mail.mkd

clean:
	rm -f mail.mkd sltp.md sltp.txt tickets.md tickets-commented.csv
