<template>
  <div :class="{tab: true, active: i === $parent.activeTab}" :style="{'margin-left':offset}">
      <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'Tab',
  props: {
    i: { type: Number, required: true }
  },
  computed: {
    offset: function(){ //first tab moves the tabs row
      return this.i===0? 0-(this.$parent.activeTab*100)+'%' : 0;
    }
  }
}
</script>
<style lang="stylus">
.tab
  display: inline-block
  vertical-align: top
  opacity: 0
  width: 100%
  box-sizing: border-box
  overflow: auto
  white-space: normal
  transition: opacity 0.7s, margin-left 0.5s ease-out
  padding: 5px
  &.active
    opacity: 1
  & > pre
    width: 100%
    box-sizing: border-box
</style>