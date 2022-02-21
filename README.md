# fluent-plugin-sigdump

[Fluentd](https://fluentd.org/) plugin to collect debug information of Fluentd.

 | Platform |  Support Version   |
 |----------|--------------------|
 | Fluentd  | >= Fluentd v1.9.3  |
 | Ruby     | Ruby 2.7.x / 3.1.x |

This plugin periodically dumps backtrace and memory profile of Fluentd by using [sigdump](https://github.com/fluent/sigdump).

In Unix-like environments, you can get the same sigdump by sending `$ kill -CONT {Fluentd-pid}`.  
You can use this plugin to save sigdump results periodically, or to use sigdump in Windows environment.

Although this is `input` plugin, this plugin directly outputs files and doesn't use `emit` function.  
So this plugin cannot work with `filter` plugins or `output` plugins.

## Installation

```sh
% gem install fluent-plugin-sigdump
```

## Configuration

### List of Options

|       Option      |                Description                |  Default  |
|-------------------|-------------------------------------------|-----------|
| `tag`             | Tag of the output events                  | `sigdump` |
| `scrape_interval` | The interval time between data collection | `900`      |
| `dir_path`        | The output directory path                 | `/tmp`    |

### Example Configuration

```
<source>
  @type sigdump
  tag sigdump         # optional
  scrape_interval 900  # optional
  dir_path "/dump"    # optional
</source>
```

You can use Unix-style path such as `/dump` in Windows too.  
You can also use Windows-style path such as `C:\\dump` in Windows.

### Output format

Please refer to [sigdump#sample-outout](https://github.com/fluent/sigdump#sample-outout).

## Copyright

* Copyright(c) 2022- Fukuda Daijiro, Fujimoto Seiji
* License
  * Apache License, Version 2.0
