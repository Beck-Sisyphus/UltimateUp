
The server can be accessed at 52.4.253.222

The team is lead by Peifeng Jing, Kexiang Xu and Minjing Zhu.

We are currently using PM2 to supervise the node.js server.
But to access it, you need to be root.
This is because only root can listen on port 80. Do:

``` bash
sudo -i
pm2 status
```

This shows a list of running servers (usually just 1).

To restart it, do:

``` bash
pm2 restart 0
```

Did you remember to pull?

``` bash
(as ubuntu user) git pull
(as root user) pm2 restart 0
```
