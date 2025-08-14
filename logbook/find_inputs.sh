#!/bin/bash

if [ $# -eq 0 ]; then
	echo 'Error: No input files provided. Use "make find_inputs".'
	exit 1
fi


for file in "$@"; do
	if make -nB "$file" >/dev/null 2>&1; then
		continue
	fi
	filename=$(basename "$file")
	candidate_folders=$(find ../tasks/*/output -type f -name "$filename" \
		-exec dirname {} \; | xargs -n1 dirname | xargs -n1 basename | sort -u)
	if [[ -z "$candidate_folders" ]]; then # Check that folder for file exists
		echo "Error: No task output folders found containing $filename."
		exit 1
	fi
	echo $filename found in following task outputs: $candidate_folders
	read -p "Enter the correct task folder: " task
	
	cat <<EOF >> Makefile
input/$filename: ../tasks/$task/output/$filename | input
	ln -s ../\$< \$@
EOF
done
