---
layout: page
title: LPhy Extensions
permalink: /extensions/
---

If your LPhy version is the latest version (v1.6.1) refer to the [current extension table](https://linguaphylo.github.io/extensions/#current-extensions), otherwise for older software refer to the [legacy extensions table](https://linguaphylo.github.io/extensions/#legacy-extensions) as the "extensions table" when following this guide. 

### Current Extensions

| Extension | Extension version | LPhy version | Homepage | Examples |
| --------  | ------------ | ------- | ---------- | -------- |
| Phylonco | [phylonco-lphy v1.2.1](https://github.com/bioDS/beast-phylonco/releases/tag/v1.2.1) | lphy v1.6.1 onwards | [https://github.com/bioDS/beast-phylonco](https://github.com/bioDS/beast-phylonco) | [phylonco-lphy-1.2.0-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.2.1/phylonco-lphy-1.2.0-examples.zip) |


### Installing the extension

__Note:__ Please remove any jar files for old versions of the extension from your `lib` directory if you have previously installed the extension.

LPhy extensions can be installed manually by downloading the extension jar(s) and placing it inside the `lib` subdirectory of your LPhy installation location.

For example, to install the [Phylonco](https://github.com/bioDS/beast-phylonco) extension for LPhy:

1. Go to the release page of the extension from the "Extension version" column in the extensions table, e.g., [phylonco-lphy v1.2.1](https://github.com/bioDS/beast-phylonco/releases/tag/v1.2.1)

2. Download the jar with the suffix `-lphy-(version number).jar`, for example [phylonco-lphy-1.2.1.jar](https://github.com/bioDS/beast-phylonco/releases/download/v1.2.0/phylonco-lphy-1.2.1.jar).

3. For LPhy version 1.6.0 onwards, additionally download the jar with the suffix `-lphy-studio-(version number).jar`. 
For example [phylonco-lphy-studio-1.2.0.jar](https://github.com/bioDS/beast-phylonco/releases/download/v1.2.1/phylonco-lphy-studio-1.2.0.jar).

3. Place both jar files inside the `lib` subdirectory of your LPhy installation

Your directory structure should look like this:

<figure class="image">
  <a href="/images/LPhyLibPhylonco.png">
    <img src="/images/LPhyLibPhylonco.png" alt="LPhy libraries">
  </a>
  <figcaption>Figure 1: Adding phylonco extension to LPhy libraries.</figcaption>
  
</figure>


### Loading examples
Examples can be found in the releases page of the extension. 
To load the examples into LPhy Studio: 

1. Go to the releases page of the extension from the "Extension version" column in the extensions table, e.g., [phylonco-lphy v1.2.1](https://github.com/bioDS/beast-phylonco/releases/tag/v1.2.1)

2. Download the`*-lphy-examples.zip` from the "Examples" column in the extensions table, e.g., [phylonco-lphy-1.2.0-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.2.1/phylonco-lphy-examples.zip)

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


### Legacy Extensions
See compatibility table for legacy versions of LPhyStudio [here](https://github.com/LinguaPhylo/linguaPhylo.github.io/edit/master/setup.md#legacy-dependencies).

| Extension | Extension version | LPhy version | Homepage | Examples |
| --------  | ------------ | ------- | --------- | ---------- |
| Phylonco | [phylonco-lphy v1.2.0](https://github.com/bioDS/beast-phylonco/releases/tag/v1.2.0) | lphy v1.6.0 onwards | [https://github.com/bioDS/beast-phylonco](https://github.com/bioDS/beast-phylonco) | [phylonco-lphy-1.2.0-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.2.0/phylonco-lphy-1.2.0-examples.zip)
| Phylonco | [phylonco-lphy v0.0.3](https://github.com/bioDS/beast-phylonco/releases/tag/v1.0.1) | lphy v1.4.0 | [https://github.com/bioDS/beast-phylonco](https://github.com/bioDS/beast-phylonco) | [phylonco-lphy-examples.zip](https://github.com/bioDS/beast-phylonco/releases/download/v1.0.0/phylonco-lphy-examples.zip) |


### Future work

Extensions can also be explored through the "LPhy Extension Manager" accessible from the menu in LPhy Studio.
The installation functionality will be added in future releases. 

