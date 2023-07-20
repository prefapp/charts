[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/aws-web-service)](https://artifacthub.io/packages/search?repo=aws-web-service)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/aws-web-service-proxified)](https://artifacthub.io/packages/search?repo=aws-web-service-proxified)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/datadog_helpers)](https://artifacthub.io/packages/search?repo=datadog_helpers)

# Charts
Generic charts for prefapp services

## Monorepo structure
```shell
├── charts
│   ├── aws-web-service
│   └── aws-web-service-proxified
│   └── datadog_helpers
├── docs
│   ├── aws-web-service
│   └── aws-web-service-proxified
│   └── datadog_helpers
├── .github
│   └── workflows
├── .gitignore
├── package.json
├── README.md
├── release-please-config.json
└── .release-please-manifest.json
```

## Steps to add a new Chart

- To create a new chart, you should add a new folder in ```charts/<your_chart_name>```

- Add your chart templates following the helm standard

- Create another folder in ```docs/<your_chart_name>```

- Add your chart to the [configuration](https://github.com/prefapp/charts/blob/master/release-please-config.json)

- Add an initial version to the [manifest](https://github.com/prefapp/charts/blob/master/.release-please-manifest.json)

## Use conventional commits

- When you commit new changes, start the commit message by the following key words:
  - Increases PATCH ```git commit -m "fix: fixing a bug!"```
  - Increases MINOR ```git commit -m "feat: my chart can render an Ingress now!"```
  - Increases MAYOR ```git commit -m "feat!: my chart is completely new and has breaking changes!"```
