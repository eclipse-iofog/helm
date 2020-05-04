# Changelog

## [v2.0.0-rc1] 

* Add support for ioFog v2-rc1

## [v1.3.0] - *unreleased

### Features

* Add chart parameters for specifying service type of Controller
  * Supported options: `LoadBalancer`, `NodePort` and `ClusterIP`
* Use new [ioFog operator](https://github.com/eclipse-iofog/iofog-operator)
* Add Custom Resource Definition for the new operator 

## [v1.2.0] - 2019-07-16

Initial release.

### Features

* Namespaced deployment of multiple Edge Compute Networks 
* Optional Custom Resouce Definitions
* Integrated smoke test suite to `helm test`

[v1.3.0-beta]: https://github.com/eclipse-iofog/helm/compare/v1.3.0-beta..v1.3.0-rc1
[v1.3.0-rc1]: https://github.com/eclipse-iofog/helm/compare/v1.3.0-rc1..v1.2.0
[v1.2.0]: https://github.com/eclipse-iofog/helm/releases/tag/v1.2.0
