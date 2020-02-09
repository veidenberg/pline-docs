<template>
  <a :href="path" class="action-button" >
    <icn v-if="icon" :name="icon"/> {{ text }}
    <badge v-if="tag" :text="tag" type="tag" vertical="middle"/>
  </a>
</template>

<script>

export default {
  name: 'Btn',
  props: {
    link: String,
    icon: String,
    text: String,
    tag: String
  },
  computed: {
    path: function(){
      return this.link.startsWith('/')? this.$withBase(this.link) : this.link;
    }
  },
}
</script>

<style lang="stylus">
.action-button
  display: inline-block
  color: #fff
  background-color: $accentColor
  margin: 0.5rem
  padding: 0.3rem 0.9rem
  border-radius: 5px
  transition: background-color .1s ease, transform .2s ease
  box-sizing: border-box
  text-decoration: none !important
  cursor: pointer
  border-bottom: 1px solid darken($accentColor, 30%)
  &:hover
    background-color: darken($accentColor, 5%)
.badge.tag
  background-color: #bbb !important
</style>