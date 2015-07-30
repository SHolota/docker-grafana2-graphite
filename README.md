Graphite + Grafana 2.1 
----------------------

This image contains a sensible default configuration of Graphite, Carbon-cache and Grafana 2.1.

### Building the image ###

The Dockerfile and supporting configuration files are available in our Github repository . This comes specially handy if you want to change any of the Graphite or Grafana settings, or simply if you want to know how the image was built.

To build the container image from the repository you just need to run the following command:
```bash
$ git clone https://github.com/SHolota/docker-grafana2-graphite.git
$ cd docker-grafana2-graphite
-- do some changes --
$ docker build -t test/grafana2
```
### Using the Docker Index ### 

This image is published under our repository on the [Docker Index](https://registry.hub.docker.com/u/sgolota/docker-grafana2-graphite/). 

To start a container with this image you just need to run the following command:
```bash
docker run -d \
	-p 3000:3000 \
	-p 2003:2003 \
	-v /srv/graphite/conf:/opt/graphite/conf \
	-v /srv/graphite/storage:/opt/graphite/storage \
	-v /srv/graphite/sqlite:/usr/share/grafana/data \
	sgolota/graphite_grafana2
```
The container exposes the following ports:

- `3000`: the Grafana web interface.
- `2003`: the Graphite port.

To stores the data on the host we use Data volumes:

- `-v /srv/graphite/conf:/opt/graphite/conf`: store graphite config file
- `-v /srv/graphite/storage:/opt/graphite/storage`: store graphite metric  
- `-v /srv/graphite/sqlite:/usr/share/grafana/data`: store database sqlite where grafana store dashboards and users info

Here is an example that stores the data at /srv/graphite/ .

### Configuring Grafana ### 

Once your container is running all you need to do is open your browser pointing to the host/port you just published.
user: admin
pass: admin (You can chanche passwor in web interface)
Then when starting your Grafana container, you must Adding the data source to Grafana (http://docs.grafana.org/datasources/graphite/)


