Tools for releasing source releases and deploying to sites.

Building and packaging a core release
```shell
task base:build-package-publish VERSION=1.2.3 BASE_NAME=core
```

Building and packaging a downstream webmaster base
```shell
task base:build-package-publish CORE_VERSION=1.2.3 VERSION=0.0.1 BASE_NAME=webmaster-kb
```

Deploying to all editor sites
```shell
task deploy:editor VERSION=1.2.3
```

