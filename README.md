# aws-ec2-elk-log

Elasticsearch, Logstash and Kibana(ELK) Log Sample Configuration and Tools.

Tested with ELK 5.x.

## Dependencies

Deployment structure:

```
  Source Hosts of Log        ELK Host
-----------------------    ---------------------------------------
| Log -> Filebeat     | -> | Logstash -> Elasticsearch -> Kibana |
-----------------------    ---------------------------------------
```

Note that Elasticsearch could be splitted out to run on a group of
hosts as cluster.

### logrotated

logrotated should be running on the source hosts of log.

### Filebeat

Filebeat is required on the source hosts of log.

Refer to https://github.com/alexzhangs/aws-ec2-filebeaat

### Elasticsearch

Elasticsearch is required on the ELK host.

Refer to https://github.com/alexzhangs/aws-ec2-elasticsearch

### Logstash

Logstash is required on the ELK host.

Refer to https://github.com/alexzhangs/aws-ec2-logstash

### Kibana

Kibana is required on the ELK host.

Refer to https://github.com/alexzhangs/aws-ec2-kibana



## File List

```
├── README.md                                      - This file.
├── install.sh                                     - Script to install configuration.
├── elasticsearch                                  - Elasticsearch tools and sample configuration.
│   ├── create-users.sh                              - Script to create user, needs X-PACK plugin.
│   ├── index.json                                   - Sample index mapping.
│   ├── roles                                        - Sample roles.
│   │   ├── admin.json
│   │   └── readonly-logs.json
│   └── users                                        - Sample users.
│       ├── alex.json
│       └── rose.json
├── filebeat                                       - Filebeat sample configuration.
│   ├── filebeat-appserver.yml
│   └── filebeat-webserver.yml
├── kibana                                         - Kibana sample configuration.
│   └── kibana.json
├── logrotated                                     - logrotated sample configuration.
│   └── elklogsample
├── logstash                                       - Logstash sample configuration.
│   └── elklogsample.conf
└── nginx                                          - Nginx sample configuration for Kibana.
    ├── nginx.conf
    └── upstream.conf
```



## Installation

```
git clone https://github.com/alexzhangs/aws-ec2-elk-log
```

About install.sh:

```
Install ELK Log Sample configuration and tools.

install.sh
	[-r]
	[-f]
	[-e]
	[-l]
	[-k]
	[-h]
OPTIONS
	[-r]

	Install configuration of logrotate.

	[-f]

	Install configuration of Filebeat.
	Any existing *.yml files under /etc/filebeat will be deleted first.

	[-e]

	TODO: Install configuration of Elasticsearch.

	[-l]

	Install configuration of Logstash.

	[-k]

	TODO: Install configuration of Kibana.

	[-h]

	This help.
```



### On source hosts of log

```
sh aws-ec2-elk-log/install.sh -r -f /var/log/elklogsample
```

### On ELK host

Automatic installation on ELK host is not working by now, `-e` and `-k` were not implementated, so far only `-l` is available.

```
sh aws-ec2-elk-log/install.sh -e -l -k
```

