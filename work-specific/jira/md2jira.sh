#!/bin/sh
#echo '========================================================='
# Convert lines
output=$( sed 's/^-----*$/----/' $1 )
# Convert titles
output=$( echo "${output}" | sed 's/^##### /h5. /g' )
output=$( echo "${output}" | sed 's/^#### /h4. /g' )
output=$( echo "${output}" | sed 's/^### /h3. /g' )
output=$( echo "${output}" | sed 's/^## /h2. /g' )
# Convert emphasis
output=$( echo "${output}" | sed 's/\*\*/*/g' )
output=$( echo "${output}" | sed '/^| --/d' )
# Convert code block
output=$( echo "${output}" | sed -E 's/^```(.+)/{code:\1}/g' )
output=$( echo "${output}" | sed 's/^```$/{code}/g' )
# Convert code inline
output=$( echo "${output}" | sed -E 's/`(.*)`/{{\1}}/g' )
# Convert numbered lists
output=$( echo "${output}" | sed 's/^1. /# /g' )
# Convert quotes
output=$( echo "${output}" | sed -E 's/^> (.*)/{quote}\1{quote} /g' )
# Convert usernames
jira_users_list="$HOME/Documentos/KnowHow/jira-users.csv"
for name in $( echo "${output}" | grep -oE '@[[:alpha:]]+' ); do
	jira_user_name=$( grep "$name" $jira_users_list | cut -d';' -f2 )
	output=$( echo "${output}" | sed -E "s/$name/$jira_user_name/g" )
done

# Print result
echo "${output}"
