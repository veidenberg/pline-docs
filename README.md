---
title: Homepage
pageClass: homepage
sidebar: false
---

<div class="header">
  <div :class="logoClass">
    <img :src="$withBase('/images/scrn_man.jpg')">
    <img :src="$withBase('/images/scrn_pline_json.jpg')">
    <div class="logoUI"></div>
  </div>
  <h1 id="main-title">Pline</h1>
  <p class="description">JSON-based web interfaces for command-line programs</p>
  <p class="action">
	  <btn text="Play video" icon="play" link="/" />
    <btn text="Live demo →︎" link="http://wasabiapp.org/pline-demo/" />
    <btn text="Get started →" link="/guide/" />
  </p>
</div>

<div v-if="fm.features && fm.features.length" class="features">
      <div v-for="(feature, index) in fm.features" :key="index" class="feature">
        <h2>{{ feature.title }}</h2>
        <p>{{ feature.details }}</p>
      </div>
</div>

## In a nutshell

### Given a JSON-formatted program description like this:

``` json
{
	"program": "remove_gaps.py",
	"name": "Gaps remover",
	"desc": "Trims gaps-only sites from the input sequence alignment",
	"options": [
		{"file": "", "required": "Input file missing!"},
		{"checkbox": "--count", "title": "Count sequences"}
	]
}
```

### Pline will output a GUI like this:

<div  class="demoUI"></div>

This interface represents a command-line script `remove_gaps.py` with two input arguments.  
[Pline documentation](/guide/) describes the process in more detail.

::: tip
The example above (and the one in the page header) is a live interface, try it out!  
Running background tasks is disabled here. For that, use a standalone Pline package from the [downloads page](/downloads/) or run the examples in the [demo webapp](http://wasabiapp.org/pline-demo/).
:::

<div class="footer">
Andres Veidenberg | 
<a href="http://loytynojalab.biocenter.helsinki.fi" target="_blank"> Löytynoja Lab<OutboundLink/> </a>, University of Helsinki
</div>

<script>

export default {
  data: function(){
    return {
      logoPlugin: false,
      demoPlugin: false,
      logoJSON: {
        program: "pline",
        URL: "http://wasabiapp.org/pline",
        name: "Pline",
        desc: "Automatic web interface generator",
        submitBtn: "Run Pline",
        options: [
          {file: ""},
          {group: "Pline options", options: []}
        ]
      },
      demoJSON: {
        program: "remove_gaps.py",
        name: "Gaps remover",
        desc: "Trims gaps-only sites from the input sequence alignment",
        options: [
          {file: "", required: "Input file missing!"},
          {checkbox: "--count", title: "Count sequences"}
        ]
      },
      logoClass: {logo: true, away: true} 
    }
  },
  computed: {
    fm(){
      return this.$page.frontmatter
    }
  },
  beforeMount(){
    this.logoPlugin = Pline.addPlugin(this.logoJSON);
    this.demoPlugin = Pline.addPlugin(this.demoJSON);
  },
  mounted(){
    this.logoPlugin.draw('.logoUI')
    this.logoClass.away = false;
    this.demoPlugin.draw('.demoUI');
  }
}
</script>

