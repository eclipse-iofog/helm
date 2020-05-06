# Changelog

## [Unreleased]

## [v2.0.0-rc1] - 2020-05-05

* Replace CRDs with ControlPlane and Application
* Simplify CRD management to leverage Helm 3 features
* Changed Helm configuration value to closely correspond with ControlPlane CRD

## [v2.0.0-beta] - 2020-03-18

* Upgrade to ioFog 2.0 components

## [v1.3.0] - 2019-11-20

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

[v2.0.0-rc1]: https://github.com/eclipse-iofog/helm/compare/v1.3.0-rc1..v2.0.0-beta
[v2.0.0-beta]: https://github.com/eclipse-iofog/helm/compare/v2.0.0-beta..v1.3.0
[v1.3.0]: https://github.com/eclipse-iofog/helm/compare/v1.3.0..v1.2.0
[v1.2.0]: https://github.com/eclipse-iofog/helm/releases/tag/v1.2.0
