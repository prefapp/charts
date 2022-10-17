[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/aws-web-service)](https://artifacthub.io/packages/search?repo=aws-web-service)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/aws-web-service-proxified)](https://artifacthub.io/packages/search?repo=aws-web-service-proxified)

# Charts
Generic charts for prefapp services

## Monorepo structure
```shell
charts
.
├── aws-web-service                 <- Chart for AWS web service
│   ├── bin                         --------
│   ├── changelog.md                       |
│   ├── CHANGELOG.md                       |
│   ├── charts                             |
│   ├── Chart.yaml                         |
│   ├── .gitignore                         |
│   ├── .helmignore                        |
│   ├── README.md                          |
│   ├── templates                          |
│   │   ├── configmap_command.yaml         |---> Chart templates
│   │   ├── configmap.yaml                 |
│   │   ├── deployment.yaml                |
│   │   ├── ingresses.yaml                 |
│   │   ├── ingress.yaml                   |
│   │   ├── secretprovider_file_mount.yaml |
│   │   ├── secretprovider.yaml            |
│   │   ├── secret.yaml                    |
│   │   ├── serviceaccount.yaml            |
│   │   └── service.yaml                   |
│   └── values.yaml                 --------
├── docs                            <- Documentation and tgzs
│   └── aws-web-service             --------
│       ├── aws-web-service-0.1.0.tgz      |
│       ├── aws-web-service-0.1.10.tgz     |
│       ├── aws-web-service-0.1.11.tgz     |
│       ├── aws-web-service-0.1.12.tgz     |
│       ├── aws-web-service-0.1.13.tgz     |
│       ├── aws-web-service-0.1.14.tgz     |
│       ├── aws-web-service-0.1.15.tgz     |
│       ├── aws-web-service-0.1.16.tgz     |
│       ├── aws-web-service-0.1.17.tgz     |
│       ├── aws-web-service-0.1.18.tgz     |
│       ├── aws-web-service-0.1.19.tgz     |
│       ├── aws-web-service-0.1.20.tgz     |
│       ├── aws-web-service-0.1.21.tgz     |---> Chart tgz for ArtifactHub
│       ├── aws-web-service-0.1.22.tgz     |
│       ├── aws-web-service-0.1.23.tgz     |
│       ├── aws-web-service-0.1.24.tgz     |
│       ├── aws-web-service-0.1.25.tgz     |
│       ├── aws-web-service-0.1.26.tgz     |
│       ├── aws-web-service-0.1.27.tgz     |
│       ├── aws-web-service-0.1.2.tgz      |
│       ├── aws-web-service-0.1.4.tgz      |
│       ├── aws-web-service-0.1.5.tgz      |
│       ├── aws-web-service-0.1.6.tgz      |
│       ├── aws-web-service-0.1.7.tgz      |
│       ├── aws-web-service-0.1.8.tgz      |
│       ├── aws-web-service-0.1.9.tgz      |
│       ├── index.yaml                     |
│       └── README.md                -------
├── .env

├── .github
│   └── workflows
│       ├── publish-chart.yaml      <- Publish chart to ArtifactHub
│       └── release-please.yaml     <- Release-please workflow
├── .gitignore
├── package.json
├── README.md
├── release-please-config.json      <- Release-please config
└── .release-please-manifest.json   <- Release-please manifest
```

## Steps to add a new Chart

- To create a new chart, you should add a new folder in the root path with the name of your chart: <your_chart_name>

- Add your chart templates following the helm standard

- Create another folder in docs/<your_chart_name>

- Add your chart to the [configuration](https://github.com/prefapp/charts/blob/master/release-please-config.json)

- Add an initial version to the [manifest](https://github.com/prefapp/charts/blob/master/.release-please-manifest.json)

## Use conventional commits

- When you commit new changes, start the commit message by the following key words:
  - Increases PATCH ```git commit -m "fix: fixing a bug!"```
  - Increases MINOR ```git commit -m "feat: my chart can render an Ingress now!"```
  - Increases MAYOR ```git commit -m "feat!: my chart is completly new and has breaking changes!"```

