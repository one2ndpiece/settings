JUST_PATH := "../"
set working-directory := JUST_PATH

SAMPLE := "this is a sample justfile"
# list
default:
  just --list sample
# test
test:
  #!/usr/bin/env sh
  TESTMAN=testman
  echo $TESTMAN
# test1 with args
[arg("arg1", long="arg1",value="hehe")]
[arg("arg2", long="arg2")]
test1 arg1=SAMPLE arg2="arg2":
  @echo "{{arg1}}"
  @echo "{{arg2}}"
  @echo "$UNK"
test2 SAMPLE="default":
  @echo "{{SAMPLE}}"
test3:
  pwd
  @echo {{invocation_directory()}}