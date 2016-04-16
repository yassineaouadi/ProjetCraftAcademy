#!/usr/bin/env ruby



#on ajoute les librairies pour json
require 'rubygems'
require 'json'

system 'echo "updating..."'
#system 'apt-get update'
#lire le fichier json
json = File.read('config.json')
obj = JSON.parse(json)
#on met dans des variables les infos du fichier json
$hostname= obj['hostname']
$banniere= obj['banniere']
$nameserver= obj['nameserver']
puts 'test du  parsing du fichier de config json'
#pour tester, on lit ces variables
puts 'hostname: '.concat( $hostname.to_s)
puts 'banniere: '.concat($banniere.to_s)
puts 'nameserver: '.concat($nameserver.to_s)
#Configurer le hostname
cibleHost=File.open("/etc/hostname", "w+")
cibleHost.write($hostname.to_s)
#Configurer la banniere d'acceuil"
cibleBan = File.open("/etc/motd" , "w+")
cibleBan.write($banniere.to_s)
#Configurer le serveur dns
cibleDns = File.open("/etc/resolv.conf" , "a+")
cibleDns.write("nameserver ".concat($nameserver.to_s))

puts'fin de la confiiguration du serveur ubuntu'

puts 'installation de nginx'
system "apt-get install -y nginx >  /dev/null 2>&1"
system "update-rc.d  nginx enable > /dev/null 2>&1 "
system "service nginx restart > /dev/null 2>&1"
system "service nginx status"

puts 'installation de redis server'
system  "apt-get -y install -y redis-server > /dev/null 2>&1"
puts 'status du service redis-server'
system " service redis-server status"
puts  'lancement du serveur '
system " service redis-server restart"
puts 'fin du deploiement de nginx et redis'

#Generation du fichier html
puts 'generation du fichier html'
cibleHtml = File.open("/usr/share/nginx/html/index.html" , "w+")
cibleHtml.write(" <!DOCTYPE html>
<html>
<head>
<title>My nginx Welcome Page</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Ceci est ma page d'acceuil  servie par nginx</h1>
<p>generation d'un fichier html servie par nginx a partir d'un script ruby .</p>
</body>
</html>
")
system "service nginx restart" 
