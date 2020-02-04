<template>
<div class="plugin-demo">
    <div class="plugin-header">
        <h3 class="plugin-name">⚙️ {{ info.name }} </h3>
        <p class="plugin-desc"> {{ desc }} </p>
        <a v-if="info.url" :href="info.url"> {{ info.url }} <OutboundLink v-if="info.url"/></a>
    </div>
    <btn :text="'📄 JSON'" :link="json_url" download/>
    <btn v-if="!pipeline" :text="'Plugin'" :icon="os" v-on:click="$parent.makeZip('plugin', name)"/>
    <btn :text="'Bundle'" :icon="os" v-on:click="$parent.makeZip('bundle', name)"/>
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
import Btn from './Btn';

export default {
  name: 'PlineTabs',
  components: { Tab, Code, Btn },
  props: {
    name: {
      type: String,
      required: true
    },
    index: {
        type: Number,
        default: 0
    },
    pipeline: Boolean,
    os: {
        type: String,
        default: 'osx'
    }
  },
  data: function(){
    return {
      activeTab : 0,
      info: { name: this.name, url: '', desc: '' },
      timeout: this.index*1000,
      jsonStr: ''
    }
  },
  computed: {
    desc: function(){
        var d = this.info.desc || this.info.description;
        if(!d) return '';
        return d.charAt(0).toUpperCase() + d.substring(1);
    },
    json_url: function(){
        const root = 'https://github.com/veidenberg/pline-plugins/raw/master/';
        if(this.pipeline) return root + 'pipelines/'+this.name+'/'+this.name+'.json';
        return root + this.name+'/plugin.json';
    }
  },
  mounted: function() { //dynamically add highlighted json code
    const self = this;
    const UItab = self.$refs.gui.$el; //tab with interface
    
    setTimeout( function(){ //json
      $.get(self.json_url)
      .done(function(json){
          console.log(json);
        UItab.innerText = '';
        Object.assign(self.info, json);
        self.jsonStr = JSON.stringify(json, null, 2);
        if(json.pipeline){
            Pline.openPipeline(json, UItab);
        } else {
            Pline.addPlugin(json).draw(UItab);
        }
      })
      .fail(function(resp){ //obj string
      console.log(resp.responseText);
        UItab.innerText = '';
        try {
            var obj = Function('"use strict"; return ('+ resp.responseText +')')();
            Object.assign(self.info, obj);
            self.jsonStr = resp.responseText;
            Pline.addPlugin(obj).draw(UItab);
        } catch(e) {
            UItab.innerText = 'JSON parsing error: '+e;
        }
      }).always(function(){
        delete self.info.options;
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