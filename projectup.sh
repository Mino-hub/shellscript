#!/bin/bash

# public
if [ ! -e "$(pwd)/public" ]; then
    mkdir public
fi

if [ -e "$(pwd)/public" ]; then
    touch "$(pwd)/public/index.php"
    mkdir "$(pwd)/public/css/"
    mkdir "$(pwd)/public/js/"
    mkdir "$(pwd)/public/img/"
fi

#application
if [ ! -e "$(pwd)/app" ]; then
    mkdir "$(pwd)/app" 
fi

if [ -e "$(pwd)/app" ]; then
    mkdir "$(pwd)/app/classes" 
    mkdir "$(pwd)/app/functions" 
    mkdir "$(pwd)/app/data" 
fi

#tmp
if [ ! -e "$(pwd)/tmp" ]; then
    mkdir "$(pwd)/tmp" 
fi

#Dockerfile
if [ ! -e "$(pwd)/docker" ]; then
    mkdir "$(pwd)/docker" 
fi

if [ ! -e "$(pwd)/docker_df" ]; then
    mkdir "$(pwd)/docker/test_df" 
    mkdir "$(pwd)/docker/ran_df" 
fi

#TestFile
if [ ! -e "$(pwd)/tests" ]; then
    mkdir "$(pwd)/tests"
    touch "$(pwd)/tests/phpunit.xml"
fi

# autoload 
cat << EOF > "$(pwd)/composer.json"
{
    "autoload": {
            "psr-4": { "c\\\":"app/classes" }
    }
}
EOF

# generate composer autoload 
composer install

# generate gitrepository
git init

# it make pre-commit for test
cat << "EOF" > "$(pwd)/.git/hooks/pre-commit"
#!/bin/bash
function testrun(){
docker run --rm --link "$1" -v $(pwd):/app peco/phpunit_pdo --configuration $(pwd)/tests/phpunit.xml
}

dbc="testdb"

if [[ -z $(awk "/${dbc}/ { print }" <(docker ps -a)) ]]; then
    docker run -d --name ${dbc} \
        -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=db -e MYSQL_USER_PASSWORD=upass -e MYSQL_USER_NAME=hoge mysql
    testrun ${dbc}
else
    if [[ -z $(awk "/${dbc}/ { print }" <(docker ps)) ]]; then
        docker start ${dbc}
        testrun ${dbc}
    else
        echo "DB alredy run!!"
        testrun ${dbc}
    fi
fi
EOF






