# Gemini 2.3 Metadata Profile schema plugin

Gemini 2.3 Metadata Profile

## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 3.8+. It's not supported in older versions so don't plug it into it!

### Adding the plugin to the source code

The best approach is to add the plugin as a submodule. Use https://github.com/geonetwork/core-geonetwork/blob/3.8.x/add-schema.sh for automatic deployment:

```
.\add-schema.sh iso19139.gemini23 http://github.com/metadata101/iso19139.gemini23 3.8.x
```

**Note: Check whether https://github.com/geonetwork/core-geonetwork/pull/3569 has been merged into the 3.8.x branch. If not, it is necessary to manually include the affected files.**

### Adding editor configuration

Editor configuration in GeoNetwork 3.8.x is done in `schemas/iso19139.gemini23/src/main/plugin/iso19139.gemini23/layout/config-editor.xml` inside each view. Default values are the following:

      <sidePanel>
        <directive data-gn-onlinesrc-list=""/>
        <directive gn-geo-publisher=""
                   data-ng-if="gnCurrentEdit.geoPublisherConfig"
                   data-config="{{gnCurrentEdit.geoPublisherConfig}}"
                   data-lang="lang"/>
        <directive data-gn-validation-report=""/>
        <directive data-gn-suggestion-list=""/>
        <directive data-gn-need-help="user-guide/describing-information/creating-metadata.html"/>
      </sidePanel>

### Build the application 

Once the application is built, the war file contains the schema plugin:

```
$ mvn clean install -Penv-prod
```

### Deploy the profile in an existing installation

The plugin can be deployed manually in an existing GeoNetwork installation:

- Copy the content of the folder schemas/iso19139.gemini23/src/main/plugin to INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.gemini23

**Note: https://github.com/geonetwork/core-geonetwork/pull/3569 will also need to be deployed in this case** 

