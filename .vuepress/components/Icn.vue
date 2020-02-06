<template>
  <img class="icon" :src="path"/>
</template>

<script>
export default {
  name: 'Icn',
  props: { name: String },
  computed: {
    path: function(){
      return '/images/icon_'+this.name+'.png';
    }
  }
}
</script>

<style lang="stylus">
.icon
  height: 1rem
  vertical-align: -0.1rem
</style>