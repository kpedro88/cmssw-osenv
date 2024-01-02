#!/bin/bash

# Pass in name and status
function die { echo $1: status $2 ;  exit $2; }

function tests() {
	# test argument quoting
	TEST=1a
	EXPECTED="hello world"
	RESULT=$(./cmssw-env --cmsos cc7 -B $PWD --pwd $PWD -- echo "$EXPECTED")
	if [ "$RESULT" != "$EXPECTED" ]; then die "Test $TEST: wrong output $RESULT (should be $EXPECTED)" 1; fi

	TEST=1b
	RESULT=$(./cmssw-env --cmsos cc7 -B $PWD --pwd $PWD --command-to-run 'echo "'"$EXPECTED"'"')
	if [ "$RESULT" != "$EXPECTED" ]; then die "Test $TEST: wrong output $RESULT (should be $EXPECTED)" 1; fi

	# test argument quoting with script
	TEST=2a
	EXPECTED=3
	RESULT=$(./cmssw-env --cmsos cc7 -B $PWD --pwd $PWD -- ./testArgs.sh 1 "2 3" 4)
	if [ "$RESULT" -ne "$EXPECTED" ]; then die "Test $TEST: incorrect number of arguments $RESULT (should be $EXPECTED)" 1; fi

	TEST=2b
	RESULT=$(./cmssw-env --cmsos cc7 -B $PWD --pwd $PWD --command-to-run './testArgs.sh 1 "2 3" 4')
	if [ "$RESULT" -ne "$EXPECTED" ]; then die "Test $TEST: incorrect number of arguments $RESULT (should be $EXPECTED)" 1; fi
}

# common setup
ln -sf ../cmssw-env .

# cvmfs-like setup
ln -sf /cvmfs/cms.cern.ch/cmsset_default.sh ../
ln -sf /cvmfs/cms.cern.ch/common/cmsos .

echo "Testing with cvmfs-like setup"
tests

# standalone setup
rm ../cmsset_default.sh
rm cmsos

echo "Testing with standalone setup"
tests
