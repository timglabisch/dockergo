from fabric.api import *

env.hosts = ['......']
env.password = '......'

def pack():
    local("tar -czf build.tar.gz htdocs --exclude=htdocs/app/cache/* --exclude=htdocs/web/dev_* --exclude=htdocs/app/logs/* --exclude=*.git/*")

def deploy():
    pack();
    put('build.tar.gz');
    run("mkdir -p /var/www/website");
    run("rm -rf /var/www/website/*");
    run("tar -xf build.tar.gz -C /var/www/website");
