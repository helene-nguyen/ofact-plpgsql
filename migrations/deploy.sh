# Export variables d'environnements
export PGUSER=ofact
export PGPASSWORD=ofact

# https://sqitch.org/docs/manual/sqitch-deploy/
# sqitch deploy [options] [<database>]
# sqitch deploy [options] [<database>] --to-change <change>

# Deploy Global :
# sqitch deploy -d ofact ofact_v1
# sqitch deploy -d ofact ofact_v2
# sqitch deploy -d ofact ofact_v3