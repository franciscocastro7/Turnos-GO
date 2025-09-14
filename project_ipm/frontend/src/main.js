import './assets/tailwind.css'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from '@/App.vue'
import router from '@/router/index.js'
import 'vue3-carousel/dist/carousel.css'
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel'

const app = createApp(App)
document.documentElement.lang = 'pt-PT'

app.component('Carousel', Carousel)
app.component('Slide', Slide)
app.component('Pagination', Pagination)
app.component('Navigation', Navigation)

app.use(createPinia())
app.use(router)

app.mount('#app')
