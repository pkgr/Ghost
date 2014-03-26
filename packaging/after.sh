#!/bin/sh

set -e

# Compile assets. This requires the full development stack...
export HOME=$(pwd)
source .profile.d/nodejs.sh
npm install --silent
git init
./node_modules/.bin/grunt init
./node_modules/.bin/grunt prod

# Install pg module
npm install pg --silent

# Setup a proper config.js file, taking settings from environment variables.
cat > config.js <<CONFIG
var path = require('path'),
    url = require('url'),
    config;

var ghost_port = process.env.PORT,
    ghost_url = process.env.GHOST_URL || ("http://127.0.0.1:" + ghost_port),
    pg_url = url.parse(process.env.DATABASE_URL);


config = {
  production: {
    url: ghost_url,
    database: {
        client: 'pg',
        connection: {
            host     : pg_url.host,
            port     : pg_url.port,
            user     : pg_url.auth.split(":")[0],
            password : pg_url.auth.split(":")[1],
            database : pg_url.pathname.replace(/^\//, ''),
            charset  : 'utf8'
        }
    },
    server: {
        host: '127.0.0.1',
        port: ghost_port
    },
    logging: false
  }
}

module.exports = config;
CONFIG
