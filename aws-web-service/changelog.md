# Change Log - aws-web-service chart

## v0.1.25 [03/08/2022]

* Set alb SSL redirec condition in ingress.

## v0.1.24 [27/07/2022]

* Delete default value in the number of replicas in the deployment.

## v0.1.23 [14/06/2022]

* Fix default docker image. The previous one has vulnerabilities.

## v0.1.20 [02/06/2022]

* Add annotations support in deployment.yaml

## v0.1.17 [25/05/2022]

* Add simple command
* Add startupProbe
* Add command entrypointFile
* Fix maintenance_mode [bug](https://github.com/prefapp/charts/issues/54)
* Fix livenessProbe identation
* Fix readinessProbe identation

## v0.1.10 [18/05/2022]

* Add default replicas.
* Add spec command in template deployment.
* Add maintenence mode > void command.
