# Cynet Agent Bosh release

* Clone this repository and execute:

  `bosh init-release`


* The config directory is created with the following contents:
  ```
  ├ config
  │   ├ blobs.yml
  │   └ final.yml
  ├ jobs
  ├ packages
  └ src
  ```

* Copy Cynet agent binary(CynetEPS) and to DefaultEpsConfig.ini `src` directory, example:
  ```
  ├ src
  │   ├── CynetEPS
  │   └── DefaultEpsConfig.ini
  ```

* Register blobs or a new version using the following command:
  ```
  bosh add-blob src/CynetEPS CynetEPS
  bosh add-blob src/DefaultEpsConfig.ini DefaultEpsConfig.ini
  ```
This populates the `blobs.yml` with blob filename, filename size, and SHA

* Update the file under `config > final.yml` to include the `blobstore_path` variable:

  ```
  blobstore:
    provider: local
    options:
      blobstore_path: /Users/bob/blobs

  name: cynet-boshrelease
  ```

* Create the Release
  ```
  bosh create-release --final --force --tarball=cynet-boshrelease.tgz
  ```

* Update the file under `runtime-config > runtime_config.yml` file and update the version number, from the output of the previous command
  ```
  version: 1
  ```

* Upload the bosh Release
  ```
  bosh upload-release cynet-boshrelease.tgz
  ```

* Update the runtime config
  ```
  bosh update-runtime-config --name=cynet runtime-config/runtime_config.yml
  ```

* Trigger `Apply Changes` from Ops Manager
