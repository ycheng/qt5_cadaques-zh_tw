awk '{print "sed -e s/" $1 "/" $2 "/g | \\"} END {print "cat"}' terms-transfer.txt > terms-transfer.sh
