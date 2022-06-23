#~ CREATE SCRIPT
export PGUSER=postgres

#& CREATE USER WITH LOGIN
createuser -l -P ofact
# Reviens à faire : createuser --login --password --pwprompt ocolis
  
#& CREATE DATABASE
createdb -O ofact ofact
# Reviens à faire : createdb --owner=ocolis ocolis

#& INIT Sqitch
sqitch init ofact_sqitch --engine pg

#& CREATE V1
sqitch add ofact_v1 -n "01 - Create tables"