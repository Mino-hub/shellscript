#!/bin/bash

function testrun(){
    # clear > /dev/pts/2
    # docker run --rm -v /home/pecodrive/Documents/project/force:/app peco/phpunit_pdo /app > /dev/pts/2
    docker run --rm --link "$1" -v /home/pecodrive/Documents/project/force:/app peco/phpunit_pdo /app 
    # docker stop "$1"
    # docker wait "$1"
    # docker rm "$1"
}

dbc="testdb"

if [[ -z $(awk "/${dbc}/ { print }" <(docker ps -a)) ]]; then
    docker run -d --name ${dbc} \
    -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=db -e MYSQL_USER_PASSWORD=upass -e MYSQL_USER_NAME=hoge mysql
    testrun 
    # testrun ${dbc}
else
    if [[ -z $(awk "/${dbc}/ { print }" <(docker ps)) ]]; then
        docker start ${dbc}
        testrun 
        # testrun ${dbc}
    else
        echo "DB alredy run!!"
        testrun 
        # testrun ${dbc}
    fi
fi
