<template>
  <div>
    <Sidebar v-if="!isLoginPage" />
    <div 
      :class="{ 
        'flex-1': true, 
        'pl-[16.666667%]': !isLoginPage && !islowerWindow,
        'bg-black': islowerWindow && !isLoginPage
      }"
    >
      <router-view />
    </div>
  </div>
</template>

<script>
import Sidebar from './components/sidebar.vue';

export default {
  name: 'App',
  components: {
    Sidebar
  },
  data() {
    return {
      islowerWindow: window.innerWidth < 1500,
    }
  },
  computed: {
    isLoginPage() {
      return this.$route.path === '/'
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
  },
  methods: {
    handleResize() {
      this.islowerWindow = window.innerWidth < 1500;
    }
  }
}
</script>