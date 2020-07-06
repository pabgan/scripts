#!/bin/sh
#echo '========================================================='
# Convert lines
output=$( sed 's/^-----*$/----/' $1 )
# Convert titles
output=$( echo "${output}" | sed 's/^##### /h5. /g' )
output=$( echo "${output}" | sed 's/^##### /h5. /g' )
output=$( echo "${output}" | sed 's/^### /h3. /g' )
output=$( echo "${output}" | sed 's/^## /h2. /g' )
# Convert emphasis
output=$( echo "${output}" | sed 's/\*\*/*/g' )
output=$( echo "${output}" | sed '/^| --/d' )
# Convert code block
output=$( echo "${output}" | sed 's/^```/{code}/g' )
# Convert code inline
output=$( echo "${output}" | sed -E 's/`(.*)`/{{\1}}/g' )
# Convert numbered lists
output=$( echo "${output}" | sed 's/^1. /# /g' )

# Print result
echo "${output}"
