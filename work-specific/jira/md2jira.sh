#!/bin/sh
#echo '========================================================='
# Convert lines
output=$( sed 's/^-----*$/----/' "${1}" )

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
output=$( echo "${output}" | sed -E 's/`([^`]+)`/{{\1}}/g' )

# Convert numbered lists
output=$( echo "${output}" | sed 's/^1. /# /g' )

# Convert quotes
output=$( echo "${output}" | sed -E 's/^> (.*)/{quote}\1{quote} /g' )

# Convert images
alt_text='\[([^]]+)\]'
img_path='\(([^)]+)\)'
output=$( echo "${output}" | sed -E "s/!${alt_text}${img_path}/!\2|thumbnail!/g" )

# Convert attachments
alt_text='\[([^]]+)\]'
img_path='\(([^)]+)\)'
output=$( echo "${output}" | sed -E "s/${alt_text}${img_path}/[^\2]/g" )

# Convert usernames
jira_users_list="$HOME/Documentos/KnowHow/jira-users.csv"
## Grep out all the words starting with '@' and containing only letters
for name in $( echo "${output}" | grep -oE '@[[:alpha:]]+' ); do
	## For each one of those names, look for its Jira ID
	jira_user_name=$( grep "${name}" "${jira_users_list}" | cut -d';' -f2 )
	## Only if the Jira ID is found, substitute the name with it
	if [ "$jira_user_name" != '' ]; then
		output=$( echo "${output}" | sed -E "s/$name/$jira_user_name/g" )
	fi
done

# Print result
echo "${output}"
