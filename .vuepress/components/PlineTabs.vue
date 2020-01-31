<template>
<div class="plugin-demo">
    <div class="plugin-header">
        <h3 class="plugin-name">⚙️ {{ json.name || '' }} </h3>
        <p class="plugin-desc"> {{ desc || '' }} </p>
        <a :if="json.url" :href="json.url"> {{ json.url }} <OutboundLink/></a>
    </div>
    <nav-link class="action-button" :item="{text:'📄 JSON', link:'/'}" />
    <nav-link class="action-button" :item="{text:'⚙️ Plugin', link:'/'}" />
    <nav-link class="action-button" :item="{text:'📦 Bundle', link:'/'}" />
    <div class="tabs">
        <div class="tabs-header">
            <span class="title" @click="activeTab = 0" :class="{active: activeTab === 0}"> Interface </span>
            <span class="title" @click="activeTab = 1" :class="{active: activeTab === 1}"> JSON </span>
        </div>  
        <div class="tabs-window">
            <Tab ref="gui" :id="0">Loading the interface...</Tab>
            <Tab ref="json" :id="1" :cut="true">
                <Code lang="json" :code="jsonStr"/>
            </Tab>
        </div>
    </div>
</div>
</template>

<script>
import Tab from './Tab';
import Code from './Code';
import NavLink from '@theme/components/NavLink.vue';

export default {
  name: 'PlineTabs',
  props: {
    name: {
      type: String,
      required: true
    },
    index: {
        type: Number,
        default: 0
    }
  },
  data: function(){
    return {
      activeTab : 0,
      json: { name: this.name },
      plugin: false,
      timeout: this.index*1000
    }
  },
  computed: {
    desc: function(){
        if(!this.json.desc) return '';
        return this.json.desc.charAt(0).toUpperCase() + this.json.desc.substring(1);
    },
    jsonStr: function(){
        return JSON.stringify(this.json, null, 2);
    }
  },
  components: { Tab, Code, NavLink },
  mounted: function() { //add highlighted json code dynamically
    const self = this;
    const UItab = self.$refs.gui.$el; //tab with interface
    const fpath = self.name.includes('.')? self.name : self.name+'/plugin.json';
    
    setTimeout( function(){ //json
      $.get('/pline/plugins/'+fpath)
      .done(function(json){
        UItab.innerText = '';
        if(json.pipeline){
            Pline.openPipeline(json, UItab);
        } else {
            self.plugin = Pline.addPlugin(json);
            self.plugin.draw(UItab);
        }
        self.json = json;
      })
      .fail(function(obj){ //obj string
        UItab.innerText = '';
        self.plugin = Pline.addPlugin(obj.responseText);
        self.plugin.draw(UItab);
        self.json = self.plugin.json;
      }).always(function(){
        setTimeout( function(){
            if(UItab.children.length){
                var jsontab = UItab.nextElementSibling;
                var UIheight = UItab.children[0].offsetHeight;
                jsontab.style.maxHeight = Math.max(UIheight, 100)+30+'px';
            }
        }, 1000);
      });
    }, self.timeout);
  }
}
</script>

<style lang="stylus">
.plugin-demo
    border-radius: 6px;
    margin: 20px 0
    padding: 10px
    &:nth-child(2n)
        background: lighten($textColor, 97%)
    a.action-button
        padding: 0.35rem 1rem
        margin: 20px 3px
    .plugin-header
        h3
            margin: 5px 0
        p
            margin: 0
            color: lighten($textColor, 20%)
    .tabs
        .tabs-header
            text-align: center
            span
                display: inline-block
                padding: 5px
                margin-bottom: -2px
                font-weight: bold
                border-bottom: 3px solid transparent
                cursor: pointer
                &:hover
                    color: orange
                &.active
                    border-bottom-color: orange
        .tabs-window
            overflow: hidden
            white-space: nowrap
            border-top: solid #ddd
            border-width: 1px
            .tab.cut
                border-bottom: 1px solid #333;
        
</style>