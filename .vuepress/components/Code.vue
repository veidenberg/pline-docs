<template>
<div :class="'language-'+language">
  <pre><code ref="code" v-html="codeHTML"></code></pre>
</div>
</template>

<script>
import Prism from 'prismjs';
import loadLanguages from 'prismjs/components/index';

export default {
  name: 'Code',
  props: {
    'code': {
      type: String,
      default: ''
    },
    'lang': {
      type: String,
      default: 'javascript'
    }
  },
  data: function(){
    return {
      language: this.lang
    }
  },
  created: function(){ //preload missing language highlight
    if (!Prism.languages[this.language]) {
      try {
        loadLanguages([language]);
      } catch (e) {
        this.language = 'javascript';
      }
    }
  },
  computed: { //turn code string to Prism html
    codeHTML: function(){
      return Prism.highlight(this.code, Prism.languages[this.language], this.language);
    }
  }
}
</script>
