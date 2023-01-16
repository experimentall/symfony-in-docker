`symfony check:requirements`
`symfony check:security`
`bin/console --env=test doctrine:database:create`
`bin/console --env=test doctrine:schema:create`
`docker rmi $(docker images -a -q) -f`
`docker system prune -a`