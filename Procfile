web: script/web.sh
codem: codem-transcode -c config/codem_development.js
http-runner: http-runner -p 9000 -w MP4Box,ant
job-states: script/job-states.sh
plugit: script/plugit.sh
tunnel: ssh -v -R *:8000:localhost:3000 madebyhiro.com -N