---
title: Downloads
pageClass: downloads
---

# Downloads

Here you can download Pline and different plug-in interfaces.
All of the files are also available on the [Github repository](https://github.com/veidenberg/pline-plugins),
but provided here as ready-to-use packages with different configurations.
In addition, each plugin here includes a live demo of the resulting interface.

To start with, here is a button to download Pline with all of its plugins in a single package:  
<btn :text="'Download for '+osname" :icon="os" :link="'/zip/pline_bundle_'+os+'.zip'"/>  
This package results in a Pline webapp that you can see on the Pline [demo site](http://wasabiapp.org/pline-demo/).

## Pline core

This arhive contains the main Pline files for generating web interfaces.  
<btn text="📦 Pline" :tag="version" :link="plinezip_url" download/>  
Unzip to a local directory or add to an existing web page (see the [guide](/guide/#installation) for details).
To add a program interface, download it from the list below or [follow the API documentation](/guide/api) to write a custom interface.

## Pline plugins

Here are listed first-party interface plugins for various command-line programs.
If you have written a Pline interface yourself, you are welcome to extend the plugins list by submitting a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests) to the [GitHub repository](https://github.com/veidenberg/pline-plugins).  

Each program interface plugin is available in 3 configurations:
- **JSON**: interface description  
  + Useful you already have both Pline and the program binary (e.g. global installation).  
  + Installation: Add it to your Pline plugins folder.
- **Plugin**: interface JSON + program binary  
  + Includes binaries for 
  <select v-model="os">
    <option v-for="ositem in oslist" v-bind:value="ositem.tag">{{ ositem.name }}</option>
  </select>
  + Unzip and drop to the Pline plugins folder.
- **Bundle**: Pline + JSON + binary  
  + Self-contained web application for running a single command-line program.
  + Includes Pline, interface JSON and the program binary. Additional interfaces can be added later.
  + Unzip and launch (see [the guide](/guide/#installation)).

Pline also runs on this website, so all the plugin interfaces here are interactive.
Click on the JSON tab to see the source file for the interface.  
To also launch the underlying command-line programs, use the [main demo site](http://wasabiapp.org:8080).  

<pline-tabs v-for="(pname, i) in plugins" :name="pname" :index="i" :os="os" />
  
## Pline pipelines

Pline can import and export pipelines as JSON files for easy reuse.
As with plugins, new pipelines can be added to this list via GitHub pull requests.
You can download the pipeline as:
- **JSON**: pipeline description file  
  + Pipeline JSON stores the prefilled input values for each pipeline step.
  + Import the JSON with the import button in the Pline program interface.
  + Assumes you already have Pline and plugins for all the programs used in the pipeline.
- **Bundle**: Pline with preinstalled plugins and the pipeline  
  + Self-contatined web application that automatically opens the pipeline with prefilled inputs.
  + Contains Pline, example input data files and the plugins (interfaces and binaries) for all the pipeline programs.
  + Unzip, launch Pline, adjust any inputs if needed, and run the pipeline.

<pline-tabs v-for="(plname, i) in pipelines" :name="plname" :index="plugins.length + 1 + i" :os="os" pipeline/>

::: tip How to use the pipeline
1. Unzip the bundle
2. Launch Pline
```sh
#in the command terminal
python path/to/Pline/pline_server.py
```
> Web browser will open Pline from `http://localhost:8000`  
3. Supply input files
> Drag the included example files to the file input area
4. Launch the pipeline
> Click `RUN`
5. View the results  
>You can visualize the pileup with e.g. [Samtools](https://samtools.github.io).
``` sh
samtools view -n path/to/Pline/data/results.bam
```
:::

<script>
export default {
  data: function(){
    return{
      plugins: [],
      pipelines: [],
      repo: 'https://api.github.com/repos/veidenberg',
      version: 'v1.0',
      os: 'osx',
      oslist: [
        {tag: 'osx', name: 'MacOS'},
        {tag: 'linux', name: 'Linux'}
      ] 
    }
  },
  computed: {
    osname: function(){
      const ositem = this.oslist.find(item => item.tag == this.os) || oslist[0];
      return ositem.name;
    },
    plinezip_url: function(){
      return 'https://github.com/veidenberg/pline/archive/'+this.version+'.zip'
    }
  },
  async beforeMount(){
    const self = this;
    //set OS name
    if(navigator.appVersion.startsWith("Linux")) self.os = 'linux';
    //fetch data from GitHub:
    //get release info
    let data = await fetch(self.repo+'/pline/releases/latest').then(resp => resp.json());
    self.version = data.tag_name;
    //get plugin names
    data = await fetch(self.repo+'/pline-plugins/contents').then(resp => resp.json());
    data.forEach( function(item){
      if(item.type == 'dir' && item.name != 'pipelines') self.plugins.push(item.name);
    });
    //get pipeline names
    data = await fetch(self.repo+'/pline-plugins/contents/pipelines').then(resp => resp.json());
    data.forEach( function(item){
      if(item.type == 'dir') self.pipelines.push(item.name);
    });
  }
}
</script>