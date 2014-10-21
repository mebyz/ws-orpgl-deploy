ws-orpgl-deploy
===============

Goal: 
====
-ws-orpgl project deployment automation.
-(Ws-orpgl is a Sf2 / angularjs / websocket based webgl project)

What you will get: 
================
-This will setup precise64 with git, nginx, php, mysql, bower, grunt, node, curl, composer

Prerequisites:
=============
-Ruby (tip : install chruby, ruby-install and pick the according version)
-bundle
-Vagrant (tip 2 : use virtualbox as a provider)

Installation and usage:
======================
- git clone https://github.com/mebyz/ws-orpgl-deploy
- cd 
- bundle install --binstubs
- vagrant up
- bundle exec cap staging deploy

=> open http://localhost:8080 in a (webgl compatible) web browser
