# Changelog

## [v3.0.0-alpha1]

Bump to v3 to synchronize with other ioFog projects

## [v2.0.0] - 2020-08-07

Update CRD spec to match Operator v2

## [v1.3.0] - 2019

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
