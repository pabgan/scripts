goodbye.md:
	echo 'Best regards.' > goodbye.md

header.md:
	echo 'Hi all.\n\nThis is the final status of ${CUS} ${VER} release validation:' > header.md

tickets.md: ../tickets.csv
	#column -t -s',' tickets.csv > tickets.md
	echo "Tickets" > tickets.md
	echo "-------" >> tickets.md
	./tickets.py ../tickets.csv tickets-comments.csv >> tickets-commented.csv
	csv2md tickets-commented.csv >> tickets.md

sltp.txt:
	docx2txt < ../sltp/System\ Test\ Plan\ -\ TeData\ 5.3.2.3.docm > sltp.txt

sltp.md: sltp.txt
	echo "System Level Test Plan" > sltp.md
	echo "----------------------" >> sltp.md
	grep -A117 -E 'Table of Contents\s+[0-9]' sltp.txt | grep -A1 -E '^[3-5]' >> sltp.md
	sed -i 's/\s\+[0-9]\+$$//' sltp.md

release-validation-status-mail.mkd: header.md info.md issues.md tickets.md sltp.md goodbye.md
	cat header.md >> release-validation-status-mail.mkd
	echo "\n" >> release-validation-status-mail.mkd
	cat info.md >> release-validation-status-mail.mkd
	echo "\n" >> release-validation-status-mail.mkd
	cat issues.md >> release-validation-status-mail.mkd
	echo "\n" >> release-validation-status-mail.mkd
	cat tickets.md >> release-validation-status-mail.mkd
	echo "\n" >> release-validation-status-mail.mkd
	cat sltp.md >> release-validation-status-mail.mkd
	echo "\n" >> release-validation-status-mail.mkd
	cat goodbye.md >> release-validation-status-mail.mkd

clean:
	rm -f release-validation-status-mail.mkd sltp.md sltp.txt tickets.md tickets-commented.csv
