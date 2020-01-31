---
title: Homepage
pageClass: homepage
sidebar: false
---

<div class="header">
  <div class="logo away">
    <img :src="$withBase('/images/scrn_man.jpg')">
    <img :src="$withBase('/images/scrn_pline_json.jpg')">
    <img :src="$withBase('/images/scrn_pline_ui.png')">
  </div>
  <h1 id="main-title">Pline</h1>
  <p class="description">JSON-based web interfaces for command-line programs</p>
  <p class="action">
	  <nav-link class="action-button" :item="{text:'▶️ Play video', link:'/'}" />
    <nav-link class="action-button" :item="{text:'Live demo →', link:'http://wasabiapp.org:8080'}" />
    <nav-link class="action-button" :item="{text:'Get started →', link:'/guide/'}" />
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

``` js
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

<div  class="plinedemo"></div>

The above interface represents a command-line script `remove_gaps.py` with two input arguments.
Read from the [Pline guide](/guide/) for more details.

::: tip
The above example is a live interface, try it out!
Launching command-line programs is disabled here, but
you can get full Pline packages from the [downloads page](/downloads/) or
run integrated examples in the [Wasabi webapp](http://wasabiapp.org).
:::

<div class="footer">
Andres Veidenberg | 
<a href="http://loytynojalab.biocenter.helsinki.fi" target="_blank"> Löytynoja Lab<OutboundLink/> </a>, University of Helsinki
</div>

<script>
import NavLink from '@theme/components/NavLink.vue';

let demoJSON = {
	program: "remove_gaps.py",
	name: "Gaps remover",
	desc: "Trims gaps-only sites from the input sequence alignment",
	options: [
		{file: "", required: "Input file missing!"},
		{checkbox: "--count", title: "Count sequences"}
	]
};

export default {
  components: { NavLink },
  computed: {
    fm(){
      return this.$page.frontmatter
    }
  },
  mounted(){
    $('.logo').removeClass('away');
    Pline.settings.pipelines = false;
    let plugin = Pline.plugins.Pline || Pline.addPlugin(demoJSON);
    plugin.draw('.plinedemo');
  }
}
</script>

