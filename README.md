# Gemini 2.3 Metadata Profile schema plugin

Gemini 2.3 Metadata Profile

## GeoNetwork versions to use with this plugin

Use GeoNetwork 3.8.x or 3.10.x (use 3.10.x if possible). A version for GeoNetwork 3.4 is also available- switch to the 3.4.x branch in this repository.

## Installing the plugin in GeoNetwork 3.10.x (recommended version)

### Adding to an existing installation

 * Download or clone this repository, ensuring you choose the correct branch. Copy `src/main/plugin/iso19139.gemini23` to `INSTALL_DIR/geonetwork/WEB_INF/data/config/schema_plugins/iso19139.gemini23` in your installation and restart GeoNetwork
 * Check that the schema is registered by visiting Admin Console -> Metadata and Templates -> Standards in GeoNetwork. If you do not see iso19139.gemini23 then it is not correctly deployed. Check your GeoNetwork log files for errors.

### Adding the plugin to the source code prior to compiling GeoNetwork

The best approach is to add the plugin as a submodule. Use https://github.com/geonetwork/core-geonetwork/blob/3.8.x/add-schema.sh for automatic deployment:

```
.\add-schema.sh iso19139.gemini23 http://github.com/metadata101/iso19139.gemini23 3.8.x
```

## Installing the plugin in GeoNetwork 3.8.x (deprecated)

### Adding to an existing installation

 * Download and extract https://github.com/AstunTechnology/geonetwork-pr4039-pr3569/blob/master/geonetwork_38x_310x_patches.zip and overwrite the `xslt` and `WEB_INF` folders with the ones from the zip file. 
 * Download or clone this repository, ensuring you choose the correct branch. Copy `src/main/plugin/iso19139.gemini23` to `INSTALL_DIR/geonetwork/WEB_INF/data/config/schema_plugins/iso19139.gemini23` in your installation and restart GeoNetwork
 * Check that the schema is registered by visiting Admin Console -> Metadata and Templates -> Standards in GeoNetwork. If you do not see iso19139.gemini23 then it is not correctly deployed. Check your GeoNetwork log files for errors.

### Adding the plugin to the source code prior to compiling GeoNetwork

The best approach is to add the plugin as a submodule. Use https://github.com/geonetwork/core-geonetwork/blob/3.8.x/add-schema.sh for automatic deployment:

```
.\add-schema.sh iso19139.gemini23 http://github.com/metadata101/iso19139.gemini23 3.8.x
```

**Note: Check whether https://github.com/geonetwork/core-geonetwork/pull/3569 has been merged into the 3.10.x branch. If not, it is necessary to manually include the affected files as below, either by adding the PR manually or adding the files from the zip before building the application**

#### Adding PR manually

If pr/3569 is unmerged, then follow this process to manually include it:

* Configure your local copy of the repository so you can check-out unmerged pull requests locally. See https://gist.github.com/piscisaureus/3342247 for instructions
* Cherry-pick the commit for pr/3569- if there are conflicts, manually resolve them
* If requested, `git stash` changes such as to pom.xml so you can re-apply them afterwards with `git stash pop`
* You may also need to make a change to `schemas/iso19115-3.2018/src\main/plugin/iso19115-3.2018/layout/layout.xsl`- overwrite **line 393** with:
```
<xsl:copy-of select="gn-fn-metadata:getFieldDirective($editorConfig, name(), name($theElement), $xpath)"/> 
```

#### OR Adding patch files from zip

Download and extract https://github.com/AstunTechnology/geonetwork-pr4039-pr3569/blob/master/geonetwork_38x_310x_patches.zip

 * Copy the contents of `WEB_INF/data/config/schema_plugins/` into `schemas`
 * Copy `xslt` into `web/src/main/webapp/`


#### Building the application 

See https://geonetwork-opensource.org/manuals/trunk/en/maintainer-guide/installing/installing-from-source-code.html. 

Once the application is built `web/target/geonetwork.war` will contain GeoNetwork with the Gemini 2.3 schema plugin included.