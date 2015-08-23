# cRapinator

** under development **

Are you highly allergic to using R, have a conniption fit when you need to develop a web application with some specialized function or data object (those statisticians!)? Thought hard about using subprocess or os.popen in python, and decided to choose server life? Then you need the cRapinator: a simple bash script to set up R, RServe, and FastRWeb to serve R plots and functions from some virtual machine. You can run this on your VM of choice (I used Amazon, ami-5189a661, t2.micro Ubuntu server), but you could use Google, Docker, etc. This is pretty raw, please fork and PR to contribute if when you improve it.

### Anticipated Issues

- A robust solution for keeping the server alive is likely needed. the rserve.conf file supports a keep-alive option, but I have not yet tested if it works.
- Better control to start and stop. Right now we can just run the '/var/FastRWeb/code/start' script to read the config and start the daemon.
