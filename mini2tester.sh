#!/bin/bash
echo "====== MINI2 TESTING SCRIPT START ======"
# this should create the project directories
echo "*** Test#1: This should generate no errors"
./mkproj.sh
echo
# this should fail
echo "*** Test#2: Duplication error"
./mkproj.sh 
echo
# this should create the project directories
echo "*** Test#3: This should generate no errors"
./mkproj.sh mini2example
echo
# this should fail
echo "*** Test#4: Duplication error"
./mkproj.sh mini2example
echo
# this should create the project directories
echo "*** Test#5: This should generate no errors"
mkdir projects
./mkproj.sh projects/mini2example
echo
# this should fail
echo "*** Test#6: Duplication error"
./mkproj.sh projects/mini2example
echo
# this should create the project directories
echo "*** Test#7: This should generate no errors"
echo "stuff" > file1.txt
echo "more stuff" > file2.txt
./mkproj.sh projects/mini2Bexample *.txt
echo
# this should fail
echo "*** Test#8: Duplication error"
./mkproj.sh projects/mini2Bexample *.txt
echo
# this should work
echo "*** Test#9: This should generate no errors"
./mkproj.sh projects/mini2Cexample *.txt
echo
# to verify
echo "*** The following tree should display the following tree: myproject, mini2example, projects/mini2example, projects/mini2Bexample with txt, mini2Cexample with txt ***"
tree
echo
# Using projects/mini2Cexample for the backup script tests
# it is assumed that mkproj.sh kept the user in the directory they invoked mkproj.sh
# the following commands should all work:
echo "*** Test#10: This should generate no errors and backup has txt files"
cd projects/mini2Cexample/backups
./mkbackup.sh
ls *.txt
echo
echo "*** Test#11: This should generate no errors and backup has testbackup.tar"
./mkbackup.sh -x testbackup.tar
ls *.tar
echo
echo "*** Test#12: This should generate no errors and backup has test2backup.tgz"
./mkbackup.sh -z test2backup.tgz
ls *.tgz
echo
echo "*** Test#13: This should generate no errors and backup has test3backup.tgz"
./mkbackup.sh -z test3backup.tgz *.txt
ls *.tgz
echo
# The following should generate errors: BOUNDARY CASES
echo "*** Test#14: BOUNDARY CASE - Files do not exist error message"
./mkbackup.sh -x test4backup.tar *.c
echo
echo "============================ END OF TESTING SCRIPT ============================"
echo "= Properly completing this testing script will result in 18/20                ="
echo "= TA testing script will have additional boundary tests for the last 2 points ="
echo "==============================================================================="

