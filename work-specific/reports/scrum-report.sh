#!/bin/zsh
# Show what I have done since last report

export PATH=$PATH:$HOME/.local/bin/

if [ "$#" -ne 1 ]; then
	days_to_report=1
else 
	days_to_report=$1
fi
echo "Scrum report since day: $(date --date="$1 days ago")"

echo "\n================== COMPLETED TASKS =================="
ommited_tags='@scrum|@qa-meeting'
for d ({$days_to_report..0}) do
	grep -E "^x $(date --iso-8601 --date="$d days ago")" ~/Documents/organizacion/todo/done.txt ~/Documents/organizacion/todo/todo.txt | grep -Ev $ommited_tags | sed 's/.*:x //g'
done

echo "\n================= OTHER THINGS DONE ================="
jrnl -from "\"$days_to_report days ago at 15:50\""

echo "================== THINGS TO TELL ==================="
todo-txt -d $XDG_CONFIG_HOME/todo/config ls @scrum | head -n -2

echo "\n===================== COMMITS ======================="
# Execute a command from another directory [1]
( cd ~/Repositorios/ASSIA/expresse/dsloExpresse/ ; cvs log -d \>"$days_to_report days ago" 2>/dev/null | grep "author: pganuza" -A1 | sed '/^date/d' | sed '/--/d' | sort | uniq )
( cd ~/Repositorios/ASSIA/expresse/dsloExpresseAdditional/ ; cvs log -d \>"$days_to_report days ago" 2>/dev/null | grep "author: pganuza" -A1 | sed '/^date/d' | sed '/--/d' | sort | uniq )
( cd ~/Repositorios/ASSIA/expresse/GuiWebServiceProject/ ; cvs log -d \>"$days_to_report days ago" 2>/dev/null | grep "author: pganuza" -A1 | sed '/^date/d' | sed '/--/d' | sort | uniq )


###################################################33
# REFERENCES
# [1] https://superuser.com/questions/271986/execute-a-command-from-another-directory-in-bash#271992
#
