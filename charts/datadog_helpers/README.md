# DataDog Helpers

- [Purpose](#purpose)
- [To install](#to-install)
- [How to use](#how-to-use)
  - [Add the library to your chart](#add-the-library-to-your-chart)
  - [Add the helpers to your templates](#add-the-helpers-to-your-templates)
    - [Logs annotation](#logs-annotation)
    - [Inject library](#inject-library)
    - [Profiler](#profiler)
    - [Correlate logs](#correlate-logs)
    - [Trace sample rate](#trace-sample-rate)
- [Values](#values)
  - [File values.yaml](#file-valuesyaml)
  - [Table values.yaml](#table-valuesyaml)
- [License](#license)

## Purpose

This chart library is a set of helpers to set a apm, profiling and labels (tags) to your pods.

## To install

```shell
helm repo add prefapp https://prefapp.github.io/charts/datadog_helpers
helm repo update
```

## How to use

### Add the library to your chart

```yaml
dependencies:
  - name: datadog_helpers
    version: 0.1.0
    repository: https://prefapp.github.io/charts/datadog_helpers
```

### Add the helpers to your templates

#### Logs annotation

```yaml
...
metadata:
  annotations:
    {{ include "helper.datadog.logs_annotation" . | nindent <number> }}
```

#### Inject library

```yaml
...
metadata:
  annotations:
    {{ include "helper.datadog.apm.inject_library" . | nindent <number> }}
```

#### Profiler

Is necesary other helper to conver key-value env to array env, i.e.:

```yaml
FOO: bar
```

to

```yaml
- name: FOO
  value: bar
```

```yaml
...
spec:
  containers:
    ...
    env:
      {{ include "helper.datadog.apm.profiler" . | nindent <number> }}
```

#### Correlate logs

```yaml
...
spec:
  containers:
    ...
    env:
      {{ include "helper.datadog.apm.correlate_logs" . | nindent <number> }}
```

#### Trace sample rate

```yaml
...
spec:
  containers:
    ...
    env:
      {{ include "helper.datadog.apm.trace_sample_rate" . | nindent <number> }}
```

## Values

### File values.yaml

```yaml
# Datadog configuration
datadog:

  # Enable or disable apm
  apm:

    # Enable or disable apm
    active: false # (true|false) | default: false

    # Enable inject library by init container
    inject_library:
      # Set a language to inject the APM libraries
      language: "js" # (js|python|ruby) | default: js

      # Version library to inject libraries according to the language
      version: "v4.0.0" # (js: v4.0.0 | python: v1.15.0 | ruby: v1.12.1) | default: v4.0.0

    # Enable or disable profiling
    profiler: false # (true|false) | default: false

    # Enable or disable correlate logs
    correlate_logs: true # (true|false) | default: true

    # Enable or disable trace sample rate to only keep traces relevant to your business and your observability
    trace_sample_rate:
      active: false # (true|false) | default: false

      # Set the sample rate for traces
      rate: 1 # (0.0-1.0) | default: 1
```

### Table values.yaml

| Name                                 | Description                                                                                              | Type    | Default  |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------- | ------- | -------- |
| datadog.apm.active                   | Enable or disable apm                                                                                    | boolean | `false`  |
| datadog.apm.inject_library.language  | Set a language to inject the APM libraries                                                               | string  | `js`     |
| datadog.apm.inject_library.version   | Version library to inject libraries according to the language                                            | string  | `v4.0.0` |
| datadog.apm.profiler                 | Enable or disable profiling                                                                              | boolean | `false`  |
| datadog.apm.correlate_logs           | Enable or disable correlate logs                                                                         | boolean | `true`   |
| datadog.apm.trace_sample_rate.active | Enable or disable trace sample rate to only keep traces relevant to your business and your observability | boolean | `false`  |
| datadog.apm.trace_sample_rate.rate   | Set the sample rate for traces                                                                           | float   | `1`      |


## License

Copyright &copy; 2023 Prefapp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
