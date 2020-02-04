<template>
  <a :href="link" class="action-button" >
    <img v-if="icon" class="icon" :src="icn"/> {{ text }}
    <badge v-if="tag" :text="tag" type="tag" vertical="middle"/>
  </a>
</template>

<script>
//import Badge from '@theme/global-components/Badge.vue';

export default {
  name: 'Btn',
  props: { link: String, icon: String, text: String, tag: String },
  data: function(){
    return {
      icn: '/images/icon_'+this.icon+'.png'
    }
  }
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
  .icon
    height: 1em
.badge.tag
  background-color: #bbb !important
</style>