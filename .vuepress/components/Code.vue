<template>
<div :class="'language-'+lang" class="extra-class">
  <pre :class="'language-'+lang"><code v-html="codeHTML"></code></pre>
</div>
</template>

<script>

export default {
  name: 'Code',
  props: {
    'code': String,
    'lang': {
      type: String,
      default: 'javascript'
    }
  },
  computed: { //turn code string to Prism html
    codeHTML(){
      //if(!Prism.languages[this.lang]) this.lang = 'javascript';
      //loadLanguages(['bash', 'json']);
      return Prism.highlight(this.code, Prism.languages[this.lang], this.lang);
    }
  }
}
</script>
