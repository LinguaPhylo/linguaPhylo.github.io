---
layout: page
title: LPhy Extensions
permalink: /extensions/
---

### Available extensions

| Extension | Beast package version | LPhy extension version | Homepage | Examples |
| -------- | ------- | ------------ | ------- | ---|
| Phylonco  | v1.0.0 | v0.0.3 | [https://github.com/bioDS/beast-phylonco](https://github.com/bioDS/beast-phylonco) | [phylonco-lphy-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.0.0/phylonco-lphy-examples.zip) |


### Manual installation

#### Installing the extension
LPhy extensions can be installed manually by downloading the extension jar and placing it inside the `lib` subdirectory of your LPhy installation location.

For example, to install the [Phylonco](https://github.com/bioDS/beast-phylonco) extension for LPhy:

1. Go to the releases page of the extension, e.g., [Phylonco releases](https://github.com/bioDS/beast-phylonco/releases)

2. Download the jar with the prefix `-lphy-(version number).jar`, for example [phylonco-lphy-0.0.3.jar](https://github.com/bioDS/beast-phylonco/releases/download/v1.0.0/phylonco-lphy-0.0.3.jar)

3. Place the jar inside the `lib` subdirectory of your LPhy installation

Your directory structure should look like this:

<figure class="image">
  <a href="/images/LPhyLibPhylonco.png">
    <img src="/images/LPhyLibPhylonco.png" alt="LPhy libraries">
  </a>
  <figcaption>Figure 1: Adding phylonco extension to LPhy libraries.</figcaption>
</figure>

__Please note:__ please remove any old version jar files from the `lib` directory, 
after you place the new version. Otherwise, it may cause error when loading the extension.


#### Loading examples
Examples can be found in the releases page of the extension. 
To load the examples into LPhy Studio: 

1. Go to the releases page of the extension, e.g., [Phylonco releases](https://github.com/bioDS/beast-phylonco/releases)

2. Download the file with the suffix `*-lphy-examples.zip`, e.g., [phylonco-lphy-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.0.0/phylonco-lphy-examples.zip)

3. Unzip the `*-lphy-examples.zip` file inside the `examples` subdirectory of your LPhy installation. Your directory structure should look like this: 

<figure class="image">
  <a href="/images/LPhyExamplesPhylonco.png">
    <img src="/images/LPhyExamplesPhylonco.png" alt="LPhy examples">
  </a>
  <figcaption>Figure 2: Adding phylonco to LPhy examples.</figcaption>
</figure>

{:start="4"}
4. Restart LPhy Studio, and these examples will be available through the Menu "File" -> "Example scripts" -> "extensionName". For the Phylonco extension, this will be available through "File" -> "Example scripts" -> "phylonco". Loading in the example script `gt16CoalErrModel.lphy` will display: 

<figure class="image">
  <a href="/images/LPhyStudioPhylonco.png">
    <img src="/images/LPhyStudioPhylonco.png" alt="Phylonco script">
  </a>
  <figcaption>Figure 3: Loading an example Phylonco script.</figcaption>
</figure>


### Future work

Extensions can also be explored through the "LPhy Extension Manager" accessible from the menu in LPhy Studio.
The installation functionality will be added in future releases. 

