# Description

An HTTP server that will echo back your request to it including the output from
the containers `env` command. Particularly useful to understand what ENV
variables are available in a container running in mesos, as well as any HTTP
information from your request including headers, path, etc. to debug load
balancers and such.

# Usage

```bash
docker run -P --name milieu --rm -it ypengineering/milieu
```

Then just curl from the host like:

```bash
curl 0:$(docker inspect milieu | grep HostPort | sed s/[^0-9]//g)
```

to see a response echoing your request and the container's env variables.

# Marathon

See the [marathon.json](marathon.json) but you can curl it like:

```bash
curl -i -H 'Content-Type: application/json' -d @marathon.json localhost:8080/v2/apps
```

where localhost:8080 is host:port of your marathon server.

# License

See [LICENSE](LICENSE)
