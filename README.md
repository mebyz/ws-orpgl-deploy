ws-orpgl-deploy
===============

Goal: 
====
- ws-orpgl project deployment automation 
- (Ws-orpgl is a Sf2 / angularjs / websocket based webgl project)

What you will get: 
================
- This will setup precise64 with git, nginx, php, mysql, bower, grunt, node, curl, composer

Prerequisites:
=============
- Ruby
- bundle
- Vagrant (tip 2 : use virtualbox as a provider)

Installation and usage:
======================
- git clone https://github.com/mebyz/ws-orpgl-deploy.git
- cd ws-orpgl-deploy
- bundle install --binstubs
- vagrant up
- bundle exec cap staging deploy

=> open http://localhost:8080/app_dev.php/login_check in a (webgl compatible) web browser
